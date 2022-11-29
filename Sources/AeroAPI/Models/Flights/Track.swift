//
//  Track.swift
//  
//
//  Created by Justin Ackermann on 11/23/22.
//

import Foundation

// Utilities
import CoreLocation

public struct FlightTrackResponse: Codable {
    var links: [String]?
    var numPages: Int?
    var positions: [FlightTrack]?
}

public struct FlightTrackRequest: AeroAPIRequest {
    
    public var faId: String
    public var historical: Bool
    public var filters: [RequestFilters]
    
    public init(_ faId: String,
         historical: Bool! = true,
         showEstimated: Bool! = true) {
        self.faId = faId
        self.historical = historical
        self.filters = [.includeEstimated(showEstimated)]
    }
    
    public func path() throws -> String {
        if historical { return "/history/flights/\(faId)/track" }
        else { return "/flights/\(faId)/track" }
    }
}

public struct FlightTrackDoc: Codable {
    public var faId: String
    public var ident: String?
    public var status: FlightStatus
    public var updated: Date
    public var track: [FlightTrack]
    
    public init(track: [FlightTrack], flightData: Flight) {
        updated = Date()
        self.faId = flightData.faFlightId
//        self.atlasId = flightData.atlasId
        self.status = flightData.status
        self.ident = flightData.ident
        self.track = track
    }
}

public struct FlightTrack: Codable {
    /// This is only null when faId was used to get track
    public var faFlightId: String?
    
    public var altitude: Int
    public var altitudeChange: AltChange
    public var groundspeed: Int
    public var heading: Int
    public var latitude: Double
    public var longitude: Double
    public var timestamp: Date
    public var updateType: UpdateType
    
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
    
    /// Request function for FlightTrack Request
    /// - Parameter request: FlightTrackRequest
    /// - Returns: FlightTrackResponse
    public func getTrack(_ request: FlightTrackRequest) async throws -> FlightTrackResponse {
        let data = try await self.request(request)
        let decoded = try decoder.decode(FlightTrackResponse.self, from: data)
        
        guard let positions = decoded.positions, !(positions.isEmpty)
        else { throw AeroAPIError.failedDecodingFlightTrackResponse }
        
        guard !(positions.isEmpty)
        else { throw AeroAPIError.flightTrackEmpty }
        
        return decoded
    }
    
    // MARK: - AeroAPI Private
}

