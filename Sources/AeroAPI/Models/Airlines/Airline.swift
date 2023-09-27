//
//  Airline.swift
//  AtlasInFlight
//
//  Created by Justin Ackermann on 4/28/22.
//

// Core iOS
import UIKit

public struct AirlineInfoRequest: AeroAPIRequest {
    public func path() throws -> String {
        return "/operators/\((icao ?? iata)!)"
    }
    
    public var icao: String?
    public var iata: String?
    public var filters: [RequestFilters]
    
    public init(icao: String) {
        self.icao = icao
        self.filters = []
    }
    
    public init(iata: String) {
        self.iata = iata
        self.filters = []
    }
}

public struct Airline: Codable {
    
    // MARK: - Codable
    public var icao: String?
    public var iata: String?
    public var name: String?
    public var callsign: String?
    public var country: String?
    public var location: String?
    public var phone: String?
    public var shortname: String?
    public var url: String?
    public var wikiUrl: String?
    public var alternatives: [Airline]?
    
    public var active: Bool! = false
    
    public var operates: String?
    public var facebook: String?
    public var twitter: String?
    public var instagram: String?
    public var youtube: String?
    public var reservations: String?
    public var email: String?
    public var website: String?
    public var loyalty: String?
    public var ally: String?
    
    // MARK: - Computed
    
    // TODO: Add 'unkwn' image asset
    public var icon: UIImage?
    { UIImage(named: icao ?? "unkwn", in: .module, compatibleWith: nil) }
    
}

extension AeroAPI {
    
    // MARK: - AeroAPI Public
    
    /// Async request function for `AirlineInfoRequest`
    /// - Parameter icao: The requested `Airline` icao string
    /// - Returns: `Airline`
    public func getAirlineInfo(icao: String) async throws -> Airline {
        let request = AirlineInfoRequest(icao: icao)
        let data = try await self.request(request)
        let decoded = try decoder.decode(Airline.self, from: data)
        return mergeWithCached(airline: decoded, icao: icao)
    }
    
    /// Async request function for `AirlineInfoRequest`
    /// - Parameter iata: The requested `Airline` iata string
    /// - Returns: `Airline`
    public func getAirlineInfo(iata: String) async throws -> Airline {
        let request = AirlineInfoRequest(iata: iata)
        let data = try await self.request(request)
        let decoded = try decoder.decode(Airline.self, from: data)
        return mergeWithCached(airline: decoded, iata: iata)
    }
    
    /// Completion based request function for `AirlineInfoRequest`
    /// - Parameter icao: The requested `Airline` icao string
    /// - Returns: Completion of optionals `Error` and `Airline`
    public func getAirlineInfo(icao: String,_ completion: @escaping (Error?, Airline?) -> Void) {
        let request = AirlineInfoRequest(icao: icao)
        self.request(request)
        { error, data in
            do {
                if let error = error { throw error }
                
                guard let data = data
                else { throw AeroAPIError.noDataReturnedForValidStatusCode }
                
                let decoded = try self.decoder.decode(Airline.self, from: data)
                completion(nil, self.mergeWithCached(airline: decoded, icao: icao))
            } catch { completion(error, nil) }
        }
    }
    
    /// Completion based request function for `AirlineInfoRequest`
    /// - Parameter iata: The requested `Airline` iata string
    /// - Returns: Completion of optionals `Error` and `Airline`
    public func getAirlineInfo(iata: String,_ completion: @escaping (Error?, Airline?) -> Void) {
        let request = AirlineInfoRequest(iata: iata)
        self.request(request)
        { error, data in
            do {
                if let error = error { throw error }
                
                guard let data = data
                else { throw AeroAPIError.noDataReturnedForValidStatusCode }
                
                let decoded = try self.decoder.decode(Airline.self, from: data)
                completion(nil, self.mergeWithCached(airline: decoded, iata: iata))
            } catch { completion(error, nil) }
        }
    }
    
    /// Merges the AeroAPI info with the cached Airline info
    /// - Parameter airline: `Airline` object that was returned by the AeroAPI
    /// - Parameter icao: `String` that's the ICAO for the aircraft information that was requested
    /// - Parameter iata: `String` that's the IATA for the aircraft information that was requested
    internal func mergeWithCached(
        airline: Airline,
        icao: String! = nil,
        iata: String! = nil
    ) -> Airline {
        if var cached = (AeroAPI.allAirlines.first(where: { ($0.icao == icao || $0.iata == iata) })) {
            cached.callsign     = airline.callsign
            cached.name         = airline.name
            cached.shortname    = airline.shortname
            cached.country      = airline.country
            cached.location     = airline.location
            cached.url          = airline.url
            cached.wikiUrl      = airline.wikiUrl
            cached.alternatives = airline.alternatives
            
            return cached
        }
        
        return airline
    }
}

extension String {
    public var airline: Airline?
    { AeroAPI.allAirlines.first(where: { $0.icao == self || $0.iata == self }) }
}
