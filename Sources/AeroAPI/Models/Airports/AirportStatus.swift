//
//  AirportStatus.swift
//  
//
//  Created by Justin Ackermann on 9/28/23.
//

import Foundation

public struct AirportStatusRequest: AeroAPIRequest {
    
    public func path() throws -> String
    { return "/airports/\(ident)/delays" }
    
    public var ident: String
    public var filters: [RequestFilters]
    
    /// A request to get the Airport Delay Status
    /// - Parameter code: The ICAO, IATA, or LID code for the airport
    init(code: String) {
        self.ident = code
        self.filters = []
    }
}

public struct AirportStatus: Codable {
    
    public var airport: String
    public var category: String
    public var color: AirportStatusColor
    public var delaySecs: Int
    public var reasons: [DelayReason]
    
}

public struct DelayReason: Codable {
    public var category: String
    public var color: AirportStatusColor
    public var delaySecs: Int
    public var reason: String
}

public enum AirportStatusColor: String, Codable {
    case red, yellow, green
}

extension AeroAPI {
    
    // MARK: - AeroAPI Public
    
    /// This method will get the `AirportStatus` and any delay reasons asynchronously
    /// - Parameter code: The ICAO, IATA or LID code for the airport. ICAO is preferred.
    /// - Returns: An `AirportStatus` object containing the length of the delay and an array of `DelayReason` objects.
    public func getAirportStatus(code: String) async throws -> AirportStatus {
        let data = try await self.request(AirportStatusRequest(code: code))
        return try decoder.decode(AirportStatus.self, from: data)
    }
    
    /// This method will get the `AirportStatus` and any delay reasons with a completion closure
    /// - Parameters:
    ///   - code: The ICAO, IATA or LID code for the airport. ICAO is preferred.
    ///   - completion: A completion with optional `Error` and `AirportStatus` objects depending on the successfulness of the API call.
    public func getAirportStatus(code: String,_ completion: @escaping (Error?, AirportStatus?) -> Void) {
        self.request(AirportStatusRequest(code: code))
        { error, data in
            do {
                if let error = error
                { throw error }
                
                guard let data = data
                else { return }
                
                let status = try self.decoder.decode(AirportStatus.self, from: data)
                completion(nil, status)
            } catch { completion(error, nil) }
        }
    }
}
