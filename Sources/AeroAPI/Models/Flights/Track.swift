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
    var url: String?
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
    var faId: String
//    var atlasId: String
    var ident: String?
    var status: FlightStatus
    var updated: Date
    var track: [FlightTrack]
    
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
    var faFlightId: String?
    
    var altitude: Int
    var altitudeChange: AltChange
    var groundspeed: Int
    var heading: Int
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var updateType: UpdateType
    
    var coord: CLLocationCoordinate2D
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
        
        return decoded
    }
}

