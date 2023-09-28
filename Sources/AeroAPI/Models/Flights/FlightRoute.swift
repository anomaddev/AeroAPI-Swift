//
//  FlightRoute.swift
//  
//
//  Created by Justin Ackermann on 9/28/23.
//

import Foundation

public struct FlightRouteRequest: AeroAPIRequest {
    
    public func path() throws -> String
    { "\(historical ? "/history" : "")/flights/\(faId)/route" }
    
    public let faId: String
    public var historical: Bool! = false
    public var filters: [RequestFilters]
    
    /// Create a `FlightRouteRequest` with a given FlightAware ID (faId).
    /// - Parameter faId: A string representation of the unique FlightAware flight ID for a given flight
    public init(faId: String) throws {
        self.faId = faId
        self.filters = []
        
        guard let flightDate = Int(faId.split(separator: "-")[1])
        else { throw AeroAPIError.faIdDateInvalid(id: faId) }
        
        let current = Date().seconds
        self.historical = current > flightDate
    }
}

public struct FlightRoute: Codable {
    
    public var routeDistance: String?
    public var fixes: [FlightFix]
    
}

public struct FlightFix: Codable {
    
    public var name: String
    public var latitude: Double?
    public var longitude: Double?
    public var distanceFromOrigin: Double?
    public var distanceThisLeg: Double?
    public var distanceToDestination: Double?
    public var outboundCourse: Double?
    public var type: String
    
}

extension AeroAPI {
    
    // MARK: - AeroAPI Public
    
    /// Get the flight route asynchronously using a FAID
    /// - Parameter faId: The unique FlightAware flight ID
    /// - Returns: A `FlightRoute` object containing the flight's route information
    public func getRoute(faId: String) async throws -> FlightRoute {
        let data = try await self.request(FlightRouteRequest(faId: faId))
        return try decoder.decode(FlightRoute.self, from: data)
    }
    
    
    /// Get the flight route using a FAID with a completion closure
    /// - Parameters:
    ///   - faId: The unique FlightAware flight ID
    ///   - completion: A completion containing optional `Error` and `FlightRoute` objects depending on the successfulness of the API call
    public func getRoute(faId: String,
                         _ completion: @escaping (Error?, FlightRoute?) -> Void) {
        do {
            let request = try FlightRouteRequest(faId: faId)
            self.request(request)
            { error, data in
                do {
                    if let error = error
                    { throw error }
                    
                    guard let data = data
                    else { throw AeroAPIError.noFlightRouteForValidRequest }
                    
                    let route = try self.decoder.decode(FlightRoute.self, from: data)
                    completion(nil, route)
                } catch { completion(error, nil) }
            }
        } catch { completion(error, nil) }
    }
}
