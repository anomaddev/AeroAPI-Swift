//
//  FlightTrack.swift
//  
//
//  Created by Justin Ackermann on 11/23/22.
//

import Foundation

// Utilities
import CoreLocation

public struct FlightTrackRequest: AeroAPIRequest {
    
    public func path() throws -> String {
        if historical { return "/history/flights/\(faId)/track" }
        else { return "/flights/\(faId)/track" }
    }
    
    public var faId: String
    public var historical: Bool = false
    public var filters: [RequestFilters]
    
    public init(_ faId: String,
                showEstimated: Bool! = true) {
        self.faId = faId
        self.filters = [.includeEstimated(showEstimated)]
    }
}

public struct FlightTrack: Codable {
    /// This is only null when faId was used to get track
    public var faFlightId: String?
    
    public var altitude: Int
    public var altitudeChange: AltChange
    public var groundspeed: Int
    public var heading: Int?
    public var latitude: Double
    public var longitude: Double
    public var timestamp: Date
    public var updateType: UpdateType?
    
    public var coord: CLLocationCoordinate2D
    { .init(latitude: latitude, longitude: longitude) }
}

public enum AltChange: String, Codable {
    case Null = "-"
    case C, D
}

public enum UpdateType: String, Codable {
    case P, O, Z, A, M, D, X, S
}

extension AeroAPI {
    
    // MARK: - AeroAPI Public
    
    /// Get the flight track of a given FAID asynchronously
    /// - Parameters:
    ///   - faId: The unique FlightAware flight ID
    ///   - includeEstimatedPositions: A `Boolean` to indicate if the returned track should include estimated tracks
    /// - Returns: An array of `FlightTrack` objects
    public func getTrack(faId: String,
                         includeEstimatedPositions: Bool! = false) async throws -> [FlightTrack] {
        let data = try await self.request(FlightTrackRequest(faId, showEstimated: includeEstimatedPositions))
        let decoded = try decoder.decode([String: [FlightTrack]].self, from: data)
        
        guard let positions = decoded["positions"]
        else { throw AeroAPIError.failedDecodingFlightTrackResponse }
        
        guard !(positions.isEmpty)
        else { throw AeroAPIError.flightTrackEmpty }
        
        return positions
    }
    
    
    /// Get the flight track of a given FAID with a completion closure
    /// - Parameters:
    ///   - faId: The unique FlightAware flight ID
    ///   - includeEstimatedPositions: A `Boolean` to indicate if the returned track should include estimated tracks
    ///   - completion: A tuple containing an optional `Error` or an array of `FlightTrack` objects, based on the successfulness of the request
    public func getTrack(faId: String,
                         includeEstimatedPositions: Bool! = false,
                         _ completion: @escaping (Error?, [FlightTrack]?) -> Void) {
        self.request(FlightTrackRequest(faId, showEstimated: includeEstimatedPositions))
        { error, data in
            if let error = error
            { completion(error, nil); return }
            
            guard let data = data,
                  let parsed = try? self.decoder.decode([String: [FlightTrack]].self, from: data)
            else { completion(AeroAPIError.noFlightTrackDataForValidRequest, nil); return }
            
            completion(nil, parsed["positions"])
        }
    }
    
    // MARK: - AeroAPI Private
}

