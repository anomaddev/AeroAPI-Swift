import Foundation
import Alamofire
import ZippyJSON

public class AeroAPI {
    
    /// Is API class in debug mode
    public static var debug: Bool = false
    
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
        dateFormatter.dateFormat = Self.dateStringFormat
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
    
    public var internalDecoder: ZippyJSONDecoder {
        let decoder = ZippyJSONDecoder()
        let dateFormatter = DateFormatter()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        //        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
    
    private init() {}
    
    /// Set the API key for the AeroAPI manager
    /// - Parameter key: API key obtained from the developer portal on FlightAware
    public func set(apiKey key: String)
    { apiKey = key }
    
    /// Makes the given request and returns the specified `Decodable`
    /// - Parameter request: `AeroAPIRequest`
    /// - Returns: The give `Decodable` object requested from the API Request
    internal func request<T: Decodable>(_ request: AeroAPIRequest) async throws -> T {
        guard let apiKey = apiKey
        else { throw AeroAPIError.apiKeyNotSet }
        
        let url = try makeUrl(request)
        let urlRequest = try URLRequest(
            url: url,
            method: .get,
            headers: [
                .init(name: "x-apikey", value: apiKey)
            ]
        )
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200
        else { throw AeroAPIError.HTTPResponseError(statusCode) }
        
        if AeroAPI.debug {
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            print("=== JSON DATA ===")
            print(json ?? [:])
            print("=================")
        }
        
        let decoded = try decoder.decode(T.self, from: data)
        return decoded
    }
    
    /// Makes the given request and returns the give `Decodable`
    /// - Parameter request: `AeroAPIRequest`
    /// - Returns: A completion of `Error` or `Data`
    internal func request<T: Decodable>(_ request: AeroAPIRequest,
                                        _ completion: @escaping (Result<T, Error>) -> Void) {
        do {
            guard let apiKey = apiKey
            else { throw AeroAPIError.apiKeyNotSet }
            
            let url = try makeUrl(request)
            let urlRequest = try URLRequest(
                url: url,
                method: .get,
                headers: [
                    .init(name: "x-apikey", value: apiKey)
                ]
            )
            
            URLSession.shared.dataTask(with: urlRequest)
            { data, response, error in
                do {
                    if let error = error { throw error }
                    
                    let statusCode = (response as? HTTPURLResponse)?.statusCode
                    guard let statusCode = statusCode, statusCode == 200
                    else { throw AeroAPIError.HTTPResponseError(statusCode) }
                    
                    guard let data = data
                    else { throw AeroAPIError.noDataReturnedForValidStatusCode }
                    
                    if AeroAPI.debug {
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                        print("=== JSON DATA ===")
                        print(json ?? [:])
                        print("=================")
                    }
                    
                    let decoded = try self.decoder.decode(T.self, from: data)
                    completion(.success(decoded))
                } catch { completion(.failure(error)) }
            }.resume()
        } catch { completion(.failure(error)) }
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
    public func loadCache() throws {
        AeroAPI.allAirports = try loadAirports()
        AeroAPI.allAirlines = try loadAirlines()
        AeroAPI.allAircraft = try loadAircraft()
    }
    
    private func loadAirports() throws -> [Airport] {
        guard let path = Bundle.module.url(forResource: "airports", withExtension: "json")
        else { throw NSError() } // THROW:
        
        let data = try Data(contentsOf: path, options: .mappedIfSafe)
        let airports = try AeroAPI.manager.internalDecoder.decode([Airport].self, from: data)
        return airports
    }
    
    private func loadAirlines() throws -> [Airline] {
        guard let path = Bundle.module.url(forResource: "airlines", withExtension: "json")
        else { throw NSError() } // THROW:
        
        let data = try Data(contentsOf: path, options: .mappedIfSafe)
        let airlines = try AeroAPI.manager.internalDecoder.decode([Airline].self, from: data)
        return airlines
    }
    
    private func loadAircraft() throws -> [Aircraft] {
        guard let path = Bundle.module.url(forResource: "aircraft", withExtension: "json")
        else { throw NSError() } // THROW:
        
        let data = try Data(contentsOf: path, options: .mappedIfSafe)
        let aircrafts = try AeroAPI.manager.internalDecoder.decode([Aircraft].self, from: data)
        return aircrafts
    }
}

public extension Bundle {
    static let AeroAPIBundle = Bundle.module.bundleIdentifier!
}
