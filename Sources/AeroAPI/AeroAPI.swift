import Foundation
import Combine
import Alamofire

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
    
    /// AeroAPI key obtained from the developer portal on FlightAware
    internal var apiKey: String?
    
    /// JSON decoder for the AeroAPI manager
    public var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
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
        
        let header = HTTPHeader(name: "x-apikey", value: apiKey)
        let url = try makeUrl(request)
        let urlRequest = try URLRequest(url: url, method: .get, headers: [header])
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200
        else { throw AeroAPIError.fall } // TODO: Change Error Code
        
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
}
#endif
