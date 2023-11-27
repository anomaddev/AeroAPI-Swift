//
//  AdvancedSearch.swift
//
//
//  Created by Justin Ackermann on 11/27/23.
//

import Foundation

extension AeroAPI {
    
    public func advancedSearch(param: AdvancedSearchParameter) async throws -> FlightDataResponse
    { return try await AeroAPI.manager.request(param) }
    
}

public enum AdvancedSearchParameter {
    
    case Origin(Airport)
    case OriginOrDest(Airport)
    case Destination(Airport)
    
    case MapBounds(MapBounds)
    
    var query: [URLQueryItem] {
        switch self {
        case .MapBounds(let bounds):
            let lon = [bounds.NECoord.longitude, bounds.NWCoord.longitude].sorted(by: { $0 < $1 })
            let lat = [bounds.NWCoord.latitude, bounds.SWCoord.latitude].sorted(by: { $0 < $1 })
            let query = "{range lat \(lat[0]) \(lat[1])} {range lon \(lon[0]) \(lon[1])} {< alt 500}"
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "max_pages", value: "5")
            ]
            
        default: return [URLQueryItem(name: "", value: "")]
        }
    }
}
