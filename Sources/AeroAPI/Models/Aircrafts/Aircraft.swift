//
//  Aircraft.swift
//  Atlas Inflight
//
//  Created by Justin Ackermann on 5/30/21.
//

// Core iOS
import UIKit

public class Aircraft: Codable {
    
    public var name: String?
    public var iata: String?
    public var ident: String?
    public var cruise: Double?
    public var range: Int?
    
}
    
//    var image: UIImage?
//    { UIImage(named: icao ?? "plane") }
    
//    var distance: Distance? {
//        if let range = range { return Distance(is: range, in: .kilometers) }
//        else { return nil }
//    }
//
//    var speed: Speed? {
//        if let mach = mach { return Speed(is: mach, in: .mach) }
//        else { return nil }
//    }
    
//    convenience init(_ row: [String]) {
//        self.init()
//
//        self.name   = row[0]
//        self.iata   = row[1]
//        self.icao   = row[2]
//        self.mach   = NumberFormatter().number(from: row[3])?.double
//        self.range  = NumberFormatter().number(from: row[4])?.int
//        self.icon   = IconAsset.plane.raw
//    }

extension String {
//    var aircraftIcao: Aircraft? {
//        do {
//            let aircraft = Models.allAircraft
//            guard !aircraft.isEmpty else { throw NSError() } // THROW:
//            return aircraft.filter { $0.icao == self }.first
//        } catch { return nil }
//    }
//
//    var aircraftIata: Aircraft? {
//        do {
//            let aircraft = Models.allAircraft
//            guard !aircraft.isEmpty else { throw NSError() } // THROW:
//            return aircraft.filter { $0.iata == self }.first
//        } catch { return nil }
//    }
//
//    var aircraft: Aircraft? {
//        do {
//            let aircraft = Models.allAircraft
//            guard !aircraft.isEmpty else { throw NSError() } // THROW:
//
//            let icao = aircraft.first { $0.icao == self }
//            let iata = aircraft.first { $0.iata == self }
//
//            guard let plane = icao ?? iata
//            else { throw AtlasError.fall }
//
//            return plane
//        } catch { return nil }
//    }
//
//    func isAircraft() throws -> Aircraft {
//        let realm = try Realm()
//        let aircraft = realm.objects(Aircraft.self)
//        let icao = aircraft.first { $0.icao == self }
//        let iata = aircraft.first { $0.iata == self }
//
//        guard let plane = icao ?? iata
//        else { throw NSError() }
//        return plane
//    }
}
