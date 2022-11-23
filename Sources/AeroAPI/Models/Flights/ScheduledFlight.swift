import Foundation
import Combine
import Alamofire

#if !os(macOS)
public struct ScheduledFlightResponse: Codable {
    public var numPages: Int! = 1
    public var scheduled: [ScheduledFlight]? = []
    public var links: [String: String]?
}

public struct ScheduledFlightRequest: AeroAPIRequest {
    public var day: Int
    public var year: Int
    public var origin: Airport
    
    public var filters: [RequestFilters]
    
    public init(for day: Int,
                of year: Int,
                from origin: Airport,
                to destination: Airport? = nil,
                filters: [RequestFilters]! = []) {
        self.day = day
        self.year = year
        self.origin = origin
        
        var fills: [RequestFilters] = filters + [.origin(origin.ident)]
        if let dest = destination { fills.append(.destination(dest.ident)) }
        self.filters = fills
    }
    
    public func path() throws -> String {
        guard let zone = origin.timezone // this is based off coordinate in real class
        else { throw NSError() } // THROW:
        
        let (start, end) = try Date.day(day, of: year, in: zone)
        
        let dateStart = start.toFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
        let dateEnd = end.toFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
        return "/schedules/\(dateStart)/\(dateEnd)"
    }
}


/// AeroAPI object for flight schedule search
public struct ScheduledFlight: Codable {
    
    public var id: String!
    public var atlasId: String? {
        let airports: String = "\(origin)-\(destination)"
        guard let day = try? scheduledOut.dayOfYear(in: .init(abbreviation: "GMT")),
              let year = try? scheduledOut.year(in: .init(abbreviation: "GMT"))
        else { return nil }
        
        return "\(ident)_\(airports)_\(year)-\(day)"
    }
    
    public var faFlightId: String?
    
    public var ident: String
    public var identIcao: String?
    public var identIata: String?
    
    public var actualIdent: String?
    public var actualIdentIcao: String?
    public var actualIdentIata: String?
    
    public var aircraftType: String?
    
    public var scheduledIn: Date!
    public var scheduledOut: Date!
    
    public var origin: String
    public var originIcao: String?
    public var originIata: String?
    public var originLid: String?
    
    public var destination: String
    public var destinationIcao: String?
    public var destinationIata: String?
    public var destinationLid: String?
    
    public var mealService: String?
    public var seatsCabinBusiness: Int?
    public var seatsCabinCoach: Int?
    public var seatsCabinFirst: Int?
    
    public var codeshares: [Codeshare]! = []
    
    // MARK: Custom
    public var updated: Date!
//    var changes: [FlightChange]?
    public var archived: Bool?
}

extension AeroAPI {
    
    // MARK: - AeroAPI Public
    
    /// Request function for ScheduledFlightsRequest
    /// - Parameter request: ScheduledFlightsRequest
    /// - Returns: ScheduledFlightResponse
    public func getScheduled(_ request: ScheduledFlightRequest) async throws -> ScheduledFlightResponse {
        let data = try await self.request(request)
        var decoded = try decoder.decode(ScheduledFlightResponse.self, from: data)
        
        guard let flights = decoded.scheduled, !(flights.isEmpty)
        else { throw AeroAPIError.failedDecodingScheduledFlightResponse }
        
        decoded.scheduled = mergeCodeshares(flights)
        return decoded
    }
    
    // MARK: - AeroAPI Private
    
    /// Parse scheduled flight results to merge child codeshares with parent
    /// - Parameter flights: all flights returned in search
    /// - Returns: remapped [ScheduledFlight] with codeshares associated to parent
    private func mergeCodeshares(_ flights: [ScheduledFlight]) -> [ScheduledFlight] {
        let children = flights.filter { $0.actualIdent != nil && $0.actualIdent != "" }
        let parents = flights.filter { $0.actualIdent == nil }
        
        let orphaned = children.filter { code -> Bool in
            !parents.contains(where: {
                flt -> Bool in code.actualIdent == flt.ident
            })
        }
        
        let orphans = Dictionary(grouping: orphaned,
                                 by: { $0.actualIdent })
            .compactMap { codeshare -> ScheduledFlight? in
                let parent = codeshare.value.first { $0.actualIdent == codeshare.key }
                let codeshares = codeshare.value.compactMap { Codeshare($0) }
                
                guard var parent = parent,
                      let actual = parent.actualIdent
                else { return nil }
                
                parent.ident = actual
                parent.identIata = parent.actualIdentIata
                parent.identIcao = parent.actualIdentIcao
                parent.codeshares = codeshares
                
                parent.actualIdent = nil
                parent.actualIdentIata = nil
                parent.actualIdentIcao = nil
                
                return parent
            }
        
        let merges = orphans.filter { flight -> Bool in
            let match = orphans.filter { share -> Bool in
                (share.codeshares?.contains(where: { $0.ident == flight.ident }) ?? false)
            }
            return match.count > 0
        }
        
        let masters = merges.compactMap { flight -> ScheduledFlight? in
            return orphans.filter {
                ($0.codeshares?.contains(where: { $0.ident == flight.ident }) ?? false)
            }.first
        }
        
        let leftovers = orphans.filter { flight -> Bool in
            !merges.contains(where: { flight.ident == $0.ident }) &&
            !masters.contains(where: { flight.ident == $0.ident })
        }
        
        let merged = masters.compactMap { master -> ScheduledFlight in
            var scheduled = master
            let match = merges.filter { flight -> Bool in
                scheduled.codeshares?.contains(where: { $0.ident == flight.ident }) ?? false
            }
            
            scheduled.codeshares?.append(contentsOf: match.map { $0.codeshares }.reduce([]) { $0 + $1 })
            return scheduled
        }
        
        merged.forEach { print("\($0.ident) | \($0.codeshares.map { $0.ident })"); print() }
        leftovers.forEach { print("\($0.ident) | \($0.codeshares.map { $0.ident })"); print() }
        return merged + leftovers + parents
    }
}
#endif
