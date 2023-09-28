//
//  AirportFlights.swift
//  
//
//  Created by Justin Ackermann on 9/28/23.
//

import Foundation

public struct AirportFlightsResponse: Codable {
    
    var scheduledArrivals:      [Flight]?
    var scheduledDepartures:    [Flight]?
    
    var arrivals:   [Flight]?
    var departures: [Flight]?
    
    var links: [String: String]
    var numPages: Int
    
}

public struct AirportFlightsRequest: AeroAPIRequest {
    
    public func path() throws -> String {
        let base = "/airports/\(ident)/flights"
        
        switch requestType {
        case .scheduledArrivals:    return base + "/scheduled_arrivals"
        case .scheduledDepartures:  return base + "/scheduled_departures"
        case .arrivals:             return base + "/arrivals"
        case .departures:           return base + "/departures"
        default: break
        }
        
        return base
    }
    
    public var ident: String
    public var requestType: AirportFlightsRequestType
    public var filters: [RequestFilters]
    
    public init(
        code: String,
        airline: String? = nil,
        type: AirportFlightsType! = .Airline,
        dateRange: (start: Date, end: Date)? = nil,
        maxPages: Int! = 1,
        cursor: String? = nil,
        requestType: AirportFlightsRequestType! = .all
    ) throws {
        self.ident = code
        self.requestType = requestType
        self.filters = [
            .airportFlightType(type),
            .maxPages(1)
        ]
        
        if let airline = airline
        { self.filters.append(.airline(airline)) }
        
        if let range = dateRange {
            let aweek = 84600 * 7
            let future = 84600 * 2
            let current = Date().seconds
            
            guard range.0.seconds < range.1.seconds
            else { throw AeroAPIError.startDateBeforeEndDate }
            
            guard (range.0.seconds > (current - aweek)) && (range.1.seconds < current + future)
            else { throw AeroAPIError.invalidDateAirportFlightsRequest }
            
            self.filters.append(.startDate(range.0))
            self.filters.append(.endDate(range.1))
        }
        
        if let cursor = cursor
        { self.filters.append(.cursor(cursor)) }
    }
}

public enum AirportFlightsRequestType: String, Codable {
    case all
    case scheduledArrivals
    case scheduledDepartures
    case arrivals
    case departures
}

public enum AirportFlightsType: String, Codable {
    case Airline
    case GeneralAviation = "General_Aviation"
}

extension AeroAPI {
    
    // MARK: - AeroAPI Public
    
    /// Get the specified flights using an `AirportFlightsRequest` asynchronously using this method.
    /// - Parameter request: A `AirportFlightsRequest` to specify the search terms of the API call.
    /// - Returns: An `AirportFlightsResponse` containing the flights the request asked for.
    public func getAirportsFlights(request: AirportFlightsRequest) async throws -> AirportFlightsResponse {
        let data = try await self.request(request)
        return try decoder.decode(AirportFlightsResponse.self, from: data)
    }
    
    
    /// Get the specified flights using a `AirportFlightsRequest` and handing with a completion closure
    /// - Parameters:
    ///   - request: A `AirportFlightsRequest` to specify the search terms of the API call.
    ///   - completion: Optional `Error` and `AirportFlightsResponse` objects depending on the successfulness of the API call.
    public func getAirportFlights(request: AirportFlightsRequest,
                                  _ completion: @escaping (Error?, AirportFlightsResponse?) -> Void) {
        self.request(request)
        { error, data in
            do {
                if let error = error
                { throw error }
                
                guard let data = data
                else { throw AeroAPIError.noAirportFlightsForValidRequest }
                
                let flights = try self.decoder.decode(AirportFlightsResponse.self, from: data)
                completion(nil, flights)
            } catch { completion(error, nil) }
        }
    }
}
