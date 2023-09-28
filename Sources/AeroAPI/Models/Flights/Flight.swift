//
//  Flight.swift
//  AeroAPI
//
//  Created by Justin Ackermann on 10/26/22.
//

// Core iOS
import Foundation

// Utilities
import SwiftDate
import NomadUtilities

public struct FlightDataResponse: Codable {
    public var numPages: Int! = 1
    public var flights: [Flight]? = []
    public var links: [String: String]?
}

public struct FlightDataRequest: AeroAPIRequest {
    
    public func path() throws -> String
    { return "\(historical ? "/history" : "")/flights/\(ident)" }
    
    public var ident: String
    public var historical: Bool! = false
    public var filters: [RequestFilters]
    
    /// Create a `FlightDataRequest` with a given FlightAware ID (faId).
    /// - Parameter faId: A string representation of the unique FlightAware flight ID for a given flight
    public init(faId: String) {
        self.ident = faId
        self.filters = [.identType(IdentType.faId.rawValue)]
    }
    
    /// Create a `FlightDataRequest` with an given identifier, with or without a `Date` range
    /// - Parameters:
    ///   - ident: The ICAO or IATA flight code, registration for General Aviation or FlightAware Flight ID
    ///   - type: The type of identifier given. Designator, FAID or Registration.
    ///   - dateRange: The optional start and end dates you would like to perform the search under
    public init(ident: String,
                type: IdentType! = .designator,
                dateRange: (start: Date, end: Date)? = nil,
                maxPages: Int! = 1,
                cursor: String? = nil) {
        
        self.ident = ident
        self.filters = [.identType(type.rawValue), .maxPages(maxPages)]
        
        if let range = dateRange {
            self.filters.append(.startDate(range.start))
            self.filters.append(.endDate(range.end))
        }
        
        if let cursor = cursor
        { self.filters.append(.cursor(cursor)) }
    }
    
    public enum IdentType: String, Codable {
        case designator
        case faId = "fa_flight_id"
        case registration
    }
}

public struct Flight: Codable {
    
    /// Either the ICAO flight number or the Registration for General Aviation
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
    
    public var scheduledOut: Date?
    public var estimatedOut: Date?
    public var actualOut: Date?
    
    public var scheduledOff: Date?
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

    /// Calculated haversine distance between airports
    public var distance: Distance
    { Distance(from: origin.airport.coordinate, to: destination.airport.coordinate) }
}

extension AeroAPI {
    
    // MARK: - AeroAPI Public
    
    
    /// Get flight information asynchronously using the unique FAID for a given flight
    /// - Parameter faId: The unique flight ID for the requested flight
    /// - Returns: An optional `Flight` object with the flight information
    public func getFlightData(faId: String) async throws -> Flight?
    { return try await getFlightData(.init(faId: faId)).flights?.first }
    
    
    /// Get flight information from a unique FAID using a completion based callback
    /// - Parameters:
    ///   - faId: The unique flight ID for the requested flight
    ///   - completion: A tuple containing an optional `Error` and `Flight` objects based on the successfulness of the request
    public func getFlightData(faId: String,_ completion: @escaping (Error?, Flight?) -> Void)
    { getFlightData(.init(faId: faId)) { error, response in completion(error, response?.flights?.first) }}
    
    /// Get flight information asynchronously from a `FlightDataRequest` using this function
    /// - Parameters:
    ///   - request: Use a `FlightDataRequest` to specify the parameters of the flight search
    /// - Returns: A `FlightDataResponse` containing the flights found using the search request
    public func getFlightData(_ request: FlightDataRequest) async throws -> FlightDataResponse {
        let data = try await self.request(request)
        return try decoder.decode(FlightDataResponse.self, from: data)
    }
    
    
    /// Get flight information from a `FlightDataRequest` using a completion based callback
    /// - Parameters:
    ///   - request: Use a `FlightDataRequest` to specify the parameters of the flight search
    ///   - completion: A tuple containing an optional `Error` and `Data` objects based on the successfulness of the request
    public func getFlightData(_ request: FlightDataRequest,
                              _ completion: @escaping (Error?, FlightDataResponse?) -> Void) {
        self.request(request) { error, data in
            if let error = error
            { completion(error, nil); return }
            
            guard let data = data,
                  let parsed = try? self.decoder.decode(FlightDataResponse.self, from: data)
            else { completion(AeroAPIError.noFlightDataForValidRequest, nil); return }
            
            completion(nil, parsed)
        }
    }
    
    // MARK: - AeroAPI Private
    
}
