import Foundation
import CoreLocation

/// Use this request for getting more Airport info from the AeroAPI
public struct AirportInfoRequest: AeroAPIRequest {
    public func path() throws -> String {
        return "/airports/\((icao ?? iata ?? code)!)"
    }
    
    public var icao: String?
    public var iata: String?
    public var code: String?
    public var filters: [RequestFilters]
    
    
    /// Init a request for more Airport info using the ICAO code
    /// - Parameter icao: The ICAO code of the airport
    public init(icao: String) {
        self.icao = icao
        self.filters = []
    }
    
    
    /// Init a request for more Airport info using the IATA code
    /// - Parameter iata: The IATA code of the airport
    public init(iata: String) {
        self.iata = iata
        self.filters = []
    }
    
    
    /// Init a request for more Airport info using any code for the Airport
    /// - Parameter code: The ICAO, IATA or LID code of the airport
    public init(code: String) {
        self.code = code
        self.filters = []
    }
}


/// An `Airport` Object contains all the airport's details
public struct Airport: Codable {
    
    /// Active code used for airport. Could be ICAO, IATA or LID code.
    public var airportCode: String
    
    /// ICAO Airport code
    public var codeIcao: String?
    
    /// IATA Airport code
    public var codeIata: String?
    
    /// Airport LID code
    public var codeLid: String?
    
    /// Name of the Airport
    public var name: String

    /// Type of Airport
    public var type: AirportType?
    
    /// Elevation in Meters
    public var elevation: Int
    
    /// City of the Airport
    public var city: String
    
    /// State or Country of the Airport
    public var state: String
    
    /// Country Code of the Airport
    public var countryCode: String
    
    /// Timezone of the Airport
    public var timezone: String
    
    /// Longitude represented as a `Double`
    public var longitude: Double
    
    /// Latitude represented as a `Double`
    public var latitude: Double
    
    public var url: String?
    public var wikiUrl: String?
    public var airportFlightsUrl: URL?
    public var alternatives: [Airport]?
    
    public var facebook: String?
    public var twitter: String?
    public var instagram: String?
    public var youtube: String?
    public var phone: String?
    public var email: String?
    
    public var coordinate: CLLocationCoordinate2D
    { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
    
//    public var timezoneCode: String?
//    public var timezone: TimeZone?
//    { TimezoneMapper.latLngToTimezone(coordinate) }
    
    // TODO: Make this hardcoded
    public var shortName: String {
        return name
            .replacingOccurrences(of: "Regional", with: "Regl.")
            .replacingOccurrences(of: "Metropolitan", with: "Metro.")
            .replacingOccurrences(of: "International", with: "Intl.")
            .replacingOccurrences(of: "Airport", with: "")
    }
}

public enum AirportType: String, Codable {
    
    case Airport
    case Heliport
    case SeaplaneBase = "Seaplane Base"
    case Balloonport
    case Ultralight
    case Gliderport
    case Stolport

}

extension AeroAPI {
    
    // MARK: - AeroAPI Public
    
    /// Async request function for `AirportInfoRequest`
    /// - Parameter code: The requested `Airport` code in ICAO, IATA or LID string
    /// - Returns: `Airport`
    public func getAirportInfo(code: String) async throws -> Airport {
        let request = AirportInfoRequest(code: code)
        let airport: Airport = try await self.request(request)
        return mergeWithCached(airport: airport, code: code)
    }
    
    /// Async request function for `AirportInfoRequest`
    /// - Parameter icao: The requested `Airport` icao string
    /// - Returns: `Airport`
    public func getAirportInfo(icao: String) async throws -> Airport {
        let request = AirportInfoRequest(icao: icao)
        let airport: Airport = try await self.request(request)
        return mergeWithCached(airport: airport, icao: icao)
    }
    
    /// Async request function for `AirportInfoRequest`
    /// - Parameter iata: The requested `Airport` iata string
    /// - Returns: `Airport`
    public func getAirportInfo(iata: String) async throws -> Airport {
        let request = AirportInfoRequest(iata: iata)
        let airport: Airport = try await self.request(request)
        return mergeWithCached(airport: airport, iata: iata)
    }
    
    /// Completion based request function for `AirportInfoRequest`
    /// - Parameter code: The requested `Airport` code string
    /// - Returns: Completion of optionals `Error` and `Airport`
    public func getAirportInfo(code: String,_ completion: @escaping (Result<Airport, Error>) -> Void) {
        let request = AirportInfoRequest(code: code)
        self.request(request)
        { (result: Result<Airport, Error>) in
            switch result {
            case .success(let airport):
                completion(.success(self.mergeWithCached(airport: airport, code: code)))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Completion based request function for `AirportInfoRequest`
    /// - Parameter icao: The requested `Airport` icao string
    /// - Returns: Completion of optionals `Error` and `Airport`
    public func getAirportInfo(icao: String,_ completion: @escaping (Result<Airport, Error>) -> Void) {
        let request = AirportInfoRequest(icao: icao)
        self.request(request)
        { (result: Result<Airport, Error>) in
            switch result {
            case .success(let airport):
                completion(.success(self.mergeWithCached(airport: airport, code: icao)))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Completion based request function for `AirportInfoRequest`
    /// - Parameter iata: The requested `Airport` iata string
    /// - Returns: Completion of optionals `Error` and `Airport`
    public func getAirportInfo(iata: String,_ completion: @escaping (Result<Airport, Error>) -> Void) {
        let request = AirportInfoRequest(iata: iata)
        self.request(request)
        { (result: Result<Airport, Error>) in
            switch result {
            case .success(let airport):
                completion(.success(self.mergeWithCached(airport: airport, code: iata)))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Merges the AeroAPI info with the cached Airport info
    /// - Parameter airport: `Airport` object that was returned by the AeroAPI
    /// - Parameter icao: `String` that's the ICAO for the aircraft information that was requested
    /// - Parameter iata: `String` that's the IATA for the aircraft information that was requested
    /// - Returns: An `Airport` object with merged data if cached data found
    internal func mergeWithCached(
        airport: Airport,
        icao: String! = nil,
        iata: String! = nil,
        code: String! = nil
    ) -> Airport {
        if var cached = (AeroAPI.allAirports.first(where: {
            ($0.codeIcao == icao || $0.codeIata == iata || $0.airportCode == code)
        })) {
            cached.airportCode  = airport.airportCode
            cached.codeLid      = airport.codeLid
            cached.name         = airport.name
            cached.type         = airport.type
            cached.elevation    = airport.elevation
            cached.city         = airport.city
            cached.state        = airport.state
            cached.longitude    = airport.longitude
            cached.latitude     = airport.latitude
            cached.timezone     = airport.timezone
            cached.countryCode  = airport.countryCode
            cached.url          = airport.url
            cached.wikiUrl      = airport.wikiUrl
            cached.airportFlightsUrl = airport.airportFlightsUrl
            cached.alternatives = airport.alternatives
            
            return cached
        }
        
        return airport
    }
}

extension String {
    public var airport: Airport?
    { AeroAPI.allAirports.first(where: { $0.codeIcao == self || $0.codeIata == self }) }
}
