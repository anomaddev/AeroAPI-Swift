import Foundation
import CoreLocation

#if !os(macOS)
public class Airport: Codable {
    
    static public func spoof(_ tampa: Bool! = true) -> Airport
    { return .init(tampa: tampa) }
    
    public var _id: String = ""
    public var icao: String?
    public var iata: String?
    public var name: String = ""
    public var city: String = ""
    public var country: String = ""
    public var lat: Double = 0.0
    public var lng: Double = 0.0
    
    public var facebook: String? = nil
    public var twitter: String? = nil
    public var instagram: String? = nil
    public var youtube: String? = nil
    public var phone: String? = nil
    public var email: String? = nil
    public var website: String? = nil
    
    public var coordinate: CLLocationCoordinate2D
    { CLLocationCoordinate2D(latitude: lat, longitude: lng) }
    
    public var timezoneCode: String?
    public var timezone: TimeZone?
    { TimezoneMapper.latLngToTimezone(coordinate) }
    
    /// Only for testing
    private init(tampa: Bool! = true) {
        _id = tampa ? "1" : "2"
        icao = tampa ? "KTPA" : "KLAX"
        iata = tampa ? "TPA" : "KLAX"
        name = tampa ? "Tampa International Airport" : "Los Angeles International Airport"
        city = tampa ? "Tampa" : "Los Angeles"
        country = tampa ? "United States" : "United States"
        lat = tampa ? 27.9772 : 33.9416
        lng = tampa ? 82.5311 : 118.4085
        timezoneCode? = tampa ? "EDT" : "PDT"
        
        facebook = nil
        twitter = nil
        instagram = nil
        youtube = nil
        phone = nil
        email = nil
        website = nil
    }
}

struct AeroAirport: Codable {
    
}

#endif
