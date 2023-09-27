import Foundation
import CoreLocation

public struct AirportInfoRequest: AeroAPIRequest {
    public func path() throws -> String {
        return "/airports/\((icao ?? iata ?? code)!)"
    }
    
    public var icao: String?
    public var iata: String?
    public var code: String?
    public var filters: [RequestFilters]
    
    public init(icao: String) {
        self.icao = icao
        self.filters = []
    }
    
    public init(iata: String) {
        self.iata = iata
        self.filters = []
    }
    
    public init(code: String) {
        self.code = code
        self.filters = []
    }
}

public struct Airport: Codable {
    
    public var airportCode: String
    public var codeIcao: String?
    public var codeIata: String?
    public var codeLid: String?
    
    public var name: String
    public var type: AirportType?
    public var elevation: Int
    public var city: String
    public var state: String
    public var countryCode: String
    public var timezone: String
    
    public var longitude: Double
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
        let data = try await self.request(request)
        let decoded = try decoder.decode(Airport.self, from: data)
        return mergeWithCached(airport: decoded, code: code)
    }
    
    /// Async request function for `AirportInfoRequest`
    /// - Parameter icao: The requested `Airport` icao string
    /// - Returns: `Airport`
    public func getAirportInfo(icao: String) async throws -> Airport {
        let request = AirportInfoRequest(icao: icao)
        let data = try await self.request(request)
        let decoded = try decoder.decode(Airport.self, from: data)
        return mergeWithCached(airport: decoded, icao: icao)
    }
    
    /// Async request function for `AirportInfoRequest`
    /// - Parameter iata: The requested `Airport` iata string
    /// - Returns: `Airport`
    public func getAirportInfo(iata: String) async throws -> Airport {
        let request = AirportInfoRequest(iata: iata)
        let data = try await self.request(request)
        let decoded = try decoder.decode(Airport.self, from: data)
        return mergeWithCached(airport: decoded, iata: iata)
    }
    
    /// Completion based request function for `AirportInfoRequest`
    /// - Parameter code: The requested `Airport` code string
    /// - Returns: Completion of optionals `Error` and `Airport`
    public func getAirportInfo(code: String,_ completion: @escaping (Error?, Airport?) -> Void) {
        let request = AirportInfoRequest(code: code)
        self.request(request)
        { error, data in
            do {
                if let error = error { throw error }
                
                guard let data = data
                else { throw AeroAPIError.noDataReturnedForValidStatusCode }
                
                let decoded = try self.decoder.decode(Airport.self, from: data)
                completion(nil, self.mergeWithCached(airport: decoded, code: code))
            } catch { completion(error, nil) }
        }
    }
    
    /// Completion based request function for `AirportInfoRequest`
    /// - Parameter icao: The requested `Airport` icao string
    /// - Returns: Completion of optionals `Error` and `Airport`
    public func getAirportInfo(icao: String,_ completion: @escaping (Error?, Airport?) -> Void) {
        let request = AirportInfoRequest(icao: icao)
        self.request(request)
        { error, data in
            do {
                if let error = error { throw error }
                
                guard let data = data
                else { throw AeroAPIError.noDataReturnedForValidStatusCode }
                
                let decoded = try self.decoder.decode(Airport.self, from: data)
                completion(nil, self.mergeWithCached(airport: decoded, icao: icao))
            } catch { completion(error, nil) }
        }
    }
    
    /// Completion based request function for `AirportInfoRequest`
    /// - Parameter iata: The requested `Airport` iata string
    /// - Returns: Completion of optionals `Error` and `Airport`
    public func getAirportInfo(iata: String,_ completion: @escaping (Error?, Airport?) -> Void) {
        let request = AirportInfoRequest(iata: iata)
        self.request(request)
        { error, data in
            do {
                if let error = error { throw error }
                
                guard let data = data
                else { throw AeroAPIError.noDataReturnedForValidStatusCode }
                
                let decoded = try self.decoder.decode(Airport.self, from: data)
                completion(nil, self.mergeWithCached(airport: decoded, iata: iata))
            } catch { completion(error, nil) }
        }
    }
    
    /// Merges the AeroAPI info with the cached Airport info
    /// - Parameter airport: `Airport` object that was returned by the AeroAPI
    /// - Parameter icao: `String` that's the ICAO for the aircraft information that was requested
    /// - Parameter iata: `String` that's the IATA for the aircraft information that was requested
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
