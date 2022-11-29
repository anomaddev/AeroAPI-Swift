//
//  Flight.swift
//  AeroAPI
//
//  Created by Justin Ackermann on 10/26/22.
//

// Core iOS
import UIKit

// Utilities
import NomadToolsX

public struct FlightDataResponse: Codable {
    public var numPages: Int! = 1
    public var flights: [Flight]? = []
    public var links: [String: String]?
}

public struct FlightDataRequest: AeroAPIRequest {
    
    public var ident: String
    public var historical: Bool! = false
    public var filters: [RequestFilters]
    
    public init(ident: String,
                type: IdentType! = .designator,
                filters: [RequestFilters]! = [],
                historical: Bool! = false) {
        self.ident = ident
        self.historical = historical
        self.filters = filters + [.identType(type.rawValue)]
    }
    
    public func path() throws -> String
    { return "\(historical ? "/history" : "")/flights/\(ident)" }
    
    public enum IdentType: String, Codable {
        case designator
        case faId = "fa_flight_id"
        case registration
    }
}

public struct Flight: Codable {
    
    public var ident: String
    public var identIcao: String?
    public var identIata: String?
    public var faFlightId: String
    public var operatorIcao: String?
    public var operatorIata: String?
    public var flightNumber: String?
    public var registration: String?
    public var atcIdent: String?
    public var inboundFaFlightId: String?
    public var codeshares: [String]
    public var codesharesIata: [String]
    public var blocked: Bool
    public var diverted: Bool
    public var cancelled: Bool
    public var positionOnly: Bool
    public var origin: FlightAirport
    public var destination: FlightAirport
    public var departureDelay: Int?
    public var arrivalDelay: Int?
    public var filedEte: Int?
    
    public var scheduledOut: Date!
    public var estimatedOut: Date?
    public var actualOut: Date?
    
    public var scheduledOff: Date!
    public var estimatedOff: Date?
    public var actualOff: Date?
    
    public var scheduledOn: Date?
    public var estimatedOn: Date?
    public var actualOn: Date?
    
    public var scheduledIn: Date!
    public var estimatedIn: Date?
    public var actualIn: Date?
    
    public var progressPercent: Int?
    public var status: FlightStatus!
    public var aircraftType: String?
    public var routeDistance: Int?
    public var filedAirspeed: Int?
    public var filedAltitude: Int?
    public var route: String?
    public var baggageClaim: String?
    public var seatsCabinBusiness: Int?
    public var seatsCabinCoach: Int?
    public var seatsCabinFirst: Int?
    public var gateOrigin: String?
    public var gateDestination: String?
    public var terminalOrigin: String?
    public var terminalDestination: String?
    public var type: String?
    
    public var archived: Bool? = false
    public var updated: Date? = Date()
//    var changes: [FlightChange]? = []
    
    // MARK: - Computed
    public var airline: Airline
    { (operatorIcao ?? operatorIata)!.airline! }

    public var delayed: Bool
    { departureDelay ?? 0 > 0 || arrivalDelay ?? 0 > 0 }

    public var ultiDepart: Date
    { actualOut ?? estimatedOut ?? scheduledOut }

    public var ultiArrive: Date
    { actualIn ?? estimatedIn ?? scheduledIn }

    public var duration: Int {
        guard let actualOut = actualOut,
              let actualIn = actualIn
        else { return (scheduledIn.since1970 - scheduledOut.since1970) }
        return (actualIn.since1970 - actualOut.since1970)
    }

    public var distance: Distance
    { Distance(from: origin.airport.coordinate, to: destination.airport.coordinate) }

    public var departureDate: Date
    { return (actualOut ?? estimatedOut ?? scheduledOut)! }

    public var arrivalDate: Date
    { return (actualIn ?? estimatedIn ?? scheduledIn)! }
    
    public var remaining: (Int, Int, Int)
    { ((estimatedIn ?? scheduledIn)!.since1970 - Date().since1970).HMS() }
}

extension AeroAPI {
    
    // MARK: - AeroAPI Public
    
    /// Request function for FlightDataRequest
    /// - Parameter request: FlightDataRequest
    /// - Returns: FliightDataResponse
    public func getFlightData(_ request: FlightDataRequest) async throws -> FlightDataResponse {
        let data = try await self.request(request)
        let decoded = try decoder.decode(FlightDataResponse.self, from: data)
        
        guard let flights = decoded.flights, !(flights.isEmpty)
        else { throw AeroAPIError.failedDecodingScheduledFlightResponse }
        
        // TODO: More Processing Here?
        // TODO: Codeshare something maybe?
        
        return decoded
    }
    
    // MARK: - AeroAPI Private
    
}
