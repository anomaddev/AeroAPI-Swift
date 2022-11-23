//
//  Airline.swift
//  AtlasInFlight
//
//  Created by Justin Ackermann on 4/28/22.
//

// Core iOS
import Foundation

public class Airline: Codable {
    
    public var id: Int
    public var ident: String?
    public var iata: String?
    public var name: String?
    public var callsign: String?
    public var country: String?
    public var active: Bool = false
    
    public var operates: String?
    public var facebook: String?
    public var twitter: String?
    public var instagram: String?
    public var youtube: String?
    public var phone: String?
    public var reservations: String?
    public var email: String?
    public var website: String?
    // @Persisted var hubs: List<Airport?>
    public var loyalty: String?
    public var ally: String?
    
}
    
//    var icon: UIImage? {
//        guard let icao = icao,
//              icao.count == 3,
//              active
//        else { return nil }
//        return Image.named(icao).image
//    }
//
//    var alliance: Alliance? {
//        if let ally = ally, ally != "" {
//            let r = try? Realm()
//            let a = r?.objects(Alliance.self).filter { $0.code == ally }
//            return a?.first
//        } else { return nil }
//    }
    
//    convenience init(_ row: [String]) {
//        self.init()
//
//        self._id = row[0]
//        self.name = row[1]
//        self.callsign = row[5]
//        self.iata = row[3]
//        self.icao = row[4]
//        self.country = row[6]
//        self.active = row[7] == "TRUE" ? true : false
//        self.logo = "\(self.icao ?? "generic").png"
//
//        operates = row[8]
//        facebook = row[9]
//        instagram = row[10]
//        twitter = row[10]
//        instagram = row[11]
//        youtube = row[12]
//        phone = row[13]
//        reservations = row[14]
//        email = row[15]
//        website = row[16]
//        //hubs = row[17]
//        loyalty = row[18]
//        ally = row[19]
//    }
//
//    static func search(airlines a: [Airline], _ text: String, matches: Bool! = false) throws -> [Airline] {
//        let text = text.lowercased()
//        var airlines = a
//
//        let iatamatch = airlines.filter { $0.iata?.lowercased() == text }
//        airlines.removeAll(where: { $0.iata?.lowercased() == text })
//
//        let icaomatch = airlines.filter { ($0.icao?.lowercased().contains(text) ?? false) }
//        airlines.removeAll(where: { $0.icao?.lowercased().contains(text) ?? false })
//
//        let namematch = airlines.filter { ($0.name ?? "").lowercased().starts(with: text) }
//        airlines.removeAll(where: { ($0.name ?? "").lowercased().starts(with: text) })
//
//        // TODO: Add City & Country
//
//        let sorted = iatamatch + icaomatch + namematch
//        return matches ? sorted : sorted + a
//    }
//
//    override static func primaryKey() -> String?
//    { return "_id" }
//}
//
//extension String {
//    var airlineIcao: Airline? {
//        do {
//            let airlines = Models.allAirlines
//            guard !airlines.isEmpty else { throw NSError() } // THROW:
//            return airlines.filter { $0.icao == self }.first
//        } catch { return nil }
//    }
//
//    var airlineIata: Airline? {
//        do {
//            let airlines = Models.allAirlines
//            guard !airlines.isEmpty else { throw NSError() } // THROW:
//            return airlines.filter { $0.iata == self }.first
//        } catch { return nil }
//    }
//
//    func airline() throws -> Airline {
//        let airlines = Models.allAirlines
//        guard !airlines.isEmpty else { throw NSError() } // THROW:
//
//        let icao = airlines.first { $0.icao == self }
//        let iata = airlines.first { $0.iata == self }
//
//        guard let airline = icao ?? iata
//        else { throw NSError() }
//        return airline
//    }
//}
