import Foundation
import CoreLocation


#if !os(macOS)
public class Airport: Codable {
    
    static public var UKWN: Airport
    { AeroAPI.allAirports.first(where: { $0.ident == "UKNN" })! }
    
    static public func spoof(_ tampa: Bool! = true) -> Airport
    { return .init(tampa: tampa) }
    
    // TODO: This is a shitty search algo
    static public func search(airports a: [Airport], _ text: String, matches: Bool! = true) throws -> [Airport] {
        let text = text.lowercased()
        var airports = a
        
        let iatamatch = airports.filter { $0.iata?.lowercased() == text }
        airports.removeAll(where: { $0.iata?.lowercased() == text })
        
        let icaomatch = airports.filter { $0.ident.lowercased() == text }
        airports.removeAll(where: { $0.ident.lowercased() == text })
        
        let namematch = airports.filter { $0.name.lowercased().starts(with: text) }
        airports.removeAll(where: { $0.name.lowercased().starts(with: text) })
        
        let citymatch = airports.filter { $0.city.lowercased().starts(with: text) }
        airports.removeAll(where: { $0.city.lowercased().starts(with: text) })
        
        // TODO: Add City & Country
        
        var sorted = iatamatch + icaomatch + namematch + citymatch
        sorted = sorted.sorted(by: { $0.iata != nil && $1.iata == nil })
        return matches ? sorted : sorted + a
    }
    
    public var ident: String
    public var iata: String?
    public var type: String?
    
    public var name: String
    public var continent: String?
    public var city: String
    public var region: String?
    public var country: String
    
    public var lat: Double
    public var long: Double
    
    public var link: String?
    public var wiki: String?
    
    public var facebook: String?
    public var twitter: String?
    public var instagram: String?
    public var youtube: String?
    public var phone: String?
    public var email: String?
    
    public var coordinate: CLLocationCoordinate2D
    { CLLocationCoordinate2D(latitude: lat, longitude: long) }
    
    public var timezoneCode: String?
    public var timezone: TimeZone?
    { TimezoneMapper.latLngToTimezone(coordinate) }
    
    /// Only for testing
    private init(tampa: Bool! = true) {
//        id = tampa ? 1 : 2
        ident = tampa ? "KTPA" : "KLAX"
        iata = tampa ? "TPA" : "KLAX"
        name = tampa ? "Tampa International Airport" : "Los Angeles International Airport"
        city = tampa ? "Tampa" : "Los Angeles"
        country = tampa ? "United States" : "United States"
        lat = tampa ? 27.9772 : 33.9416
        long = tampa ? -82.5311 : 118.4085
        timezoneCode? = tampa ? "EDT" : "PDT"
        
        facebook = nil
        twitter = nil
        instagram = nil
        youtube = nil
        phone = nil
        email = nil
    }
}

struct AeroAirport: Codable {
    
}

extension String {
    public var airport: Airport?
    { AeroAPI.allAirports.first(where: { $0.ident == self || $0.iata == self }) }
}

#endif
