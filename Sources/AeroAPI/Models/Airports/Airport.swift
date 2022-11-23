import Foundation
import CoreLocation


#if !os(macOS)
public class Airport: Codable {
    
    static public func spoof(_ tampa: Bool! = true) -> Airport
    { return .init(tampa: tampa) }
    
    public var id: Int
    public var ident: String
    public var iata: String?
    public var type: String?
    
    public var name: String
    public var continent: String?
    public var city: String
    public var region: String?
    public var country: String
    
    public var lat: String
    public var long: String
    
    public var link: String?
    public var wiki: String?
    
    public var facebook: String?
    public var twitter: String?
    public var instagram: String?
    public var youtube: String?
    public var phone: String?
    public var email: String?
    
    public var coordinate: CLLocationCoordinate2D
    { CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!) }
    
    public var timezoneCode: String?
    public var timezone: TimeZone?
    { TimezoneMapper.latLngToTimezone(coordinate) }
    
    /// Only for testing
    private init(tampa: Bool! = true) {
        id = tampa ? 1 : 2
        ident = tampa ? "KTPA" : "KLAX"
        iata = tampa ? "TPA" : "KLAX"
        name = tampa ? "Tampa International Airport" : "Los Angeles International Airport"
        city = tampa ? "Tampa" : "Los Angeles"
        country = tampa ? "United States" : "United States"
        lat = tampa ? "27.9772" : "33.9416"
        long = tampa ? "82.5311" : "118.4085"
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

#endif
