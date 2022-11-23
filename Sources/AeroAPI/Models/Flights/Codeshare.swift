import Foundation

#if !os(macOS)
public struct Codeshare: Codable {
    
    var ident: String
    var identIcao: String?
    var identIata: String?
    
    var actualIdent: String?
    
    init(_ flight: ScheduledFlight) {
        ident = flight.ident
        identIcao = flight.identIcao
        identIata = flight.identIata
        actualIdent = flight.actualIdent // THROW:
    }
    
    init(_ icao: String, actual: String) {
        ident = icao
        identIcao = icao
        actualIdent = actual
    }
}
#endif
