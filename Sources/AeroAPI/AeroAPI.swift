import Foundation
import ZippyJSON

#if !os(macOS)
public class AeroAPI {
    
    /// Is API class in testing mode
    public static var testing: Bool = false
    
    /// Base URL Components for the AeroAPI
    private static var components: URLComponents = URLComponents()
    
    /// Default string for date formatting
    internal static var dateStringFormat: String = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    
    /// Shared instance of the AeroAPI manager
    public static var manager: AeroAPI = {
        let api = AeroAPI()
        
        components.scheme = "https"
        components.host = "aeroapi.flightaware.com"
        
        return api
    }()
    
    /// All airport data available to cache
    public static var allAirports: [Airport] = []
    public static var allAirlines: [Airline] = []
    public static var allAircraft: [Aircraft] = []
    
    /// AeroAPI key obtained from the developer portal on FlightAware
    internal var apiKey: String?
    
    /// JSON decoder for the AeroAPI manager
    public var decoder: ZippyJSONDecoder {
        let decoder = ZippyJSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
    
    public var internalDecoder: ZippyJSONDecoder {
        let decoder = ZippyJSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        //        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
    
    private init() {}
    
    /// Set the API key for the AeroAPI manager
    /// - Parameter key: API key obtained from the developer portal on FlightAware
    public func set(apiKey key: String)
    { apiKey = key }
    
    /// Makes the given request and returns Data
    /// - Parameter request: AeroAPIRequest
    /// - Returns: Data of the API Request
    internal func request(_ request: AeroAPIRequest) async throws -> Data {
        guard let apiKey = apiKey
        else { throw AeroAPIError.apiKeyNotSet }
        
        let url = try makeUrl(request)
        let urlRequest = try URLRequest(url: url,
                                        method: .get,
                                        headers: [
                                            .init(name: "x-apikey", value: apiKey)
                                        ])
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200
        else { throw AeroAPIError.fall } // TODO: Change Error Code
        
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        print("=== JSON DATA ===")
        print(json)
        print("=================")
        
        return data
    }
    
    /// Makes the url of the API all for the given AeroAPIRequest
    /// - Parameter query: AeroAPIRequest of call
    /// - Returns: URL rendererd with components
    internal func makeUrl(_ query: AeroAPIRequest) throws -> URL {
        let path = try query.path()
        
        var components = AeroAPI.components
        components.path = "/aeroapi" + path
        components.queryItems = try query.request()
        
        guard let url = components.url
        else { throw AeroAPIError.invalidURLFromComponents }
        print("REQUESTING: ")
        print(url.absoluteString)
        print()
        return url
    }
    
    // MARK: - Caching Functions
    public func loadAirports() async throws -> [Airport] {
        guard let path = Bundle.module.url(forResource: "airports", withExtension: "json")
        else { throw NSError() } // THROW:
        
        let data = try Data(contentsOf: path, options: .mappedIfSafe)
        let airports = try AeroAPI.manager.internalDecoder.decode([Airport].self, from: data)
        return airports
    }
    
    public func loadAirlines() async throws -> [Airline] {
        guard let path = Bundle.module.url(forResource: "airlines", withExtension: "json")
        else { throw NSError() } // THROW:
        
        let data = try Data(contentsOf: path, options: .mappedIfSafe)
        let airlines = try AeroAPI.manager.internalDecoder.decode([Airline].self, from: data)
        return airlines
    }
    
    public func loadAircraft() async throws -> [Aircraft] {
        guard let path = Bundle.module.url(forResource: "aircraft", withExtension: "json")
        else { throw NSError() } // THROW:
        
        let data = try Data(contentsOf: path, options: .mappedIfSafe)
        let aircrafts = try AeroAPI.manager.internalDecoder.decode([Aircraft].self, from: data)
        return aircrafts
    }
}

extension Bundle {
    public static let AeroAPIBundle = Bundle.module.bundleIdentifier!
}
#endif
