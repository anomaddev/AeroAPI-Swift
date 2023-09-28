import Foundation

public protocol AeroAPIRequest: Codable {
    var filters: [RequestFilters] { get set }
    
    func path() throws -> String
    func request() throws -> [URLQueryItem]
}

public extension AeroAPIRequest {
    func request() throws -> [URLQueryItem] {
        return self.filters.compactMap { filter -> URLQueryItem in
            switch filter {
            case .ident(let ident):
                return URLQueryItem(name: "ident", value: ident)
                
            case .identType(let type):
                return URLQueryItem(name: "ident_type", value: type)
                
            case .airline(let airline):
                return URLQueryItem(name: "airline", value: airline)
                
            case .origin(let origin):
                return URLQueryItem(name: "origin", value: origin)
                
            case .destination(let dest):
                return URLQueryItem(name: "destination", value: dest)
                
            case .startDate(let start):
                return URLQueryItem(name: "start", value: start.toFormat(AeroAPI.dateStringFormat))
                
            case .endDate(let end):
                return URLQueryItem(name: "end", value: end.toFormat(AeroAPI.dateStringFormat))
                
            case .flightNumber(let number):
                return URLQueryItem(name: "flight_number", value: "\(number)")
                
            case .includeCodeshares(let include):
                return URLQueryItem(name: "included_codeshares", value: "\(include)")
                
            case .includeEstimated(let include):
                return URLQueryItem(name: "include_estimated_positions", value: "\(include)")
                
            case .cursor(let cursor):
                return URLQueryItem(name: "cursor", value: cursor)
                
            case .maxPages(let pages):
                return URLQueryItem(name: "max_pages", value: "\(pages)")
            }
        }
    }
}

public enum RequestFilters: Codable {
    case ident(String)
    case identType(String)
    
    case airline(String)
    case origin(String)
    case destination(String)
    
    case startDate(Date)
    case endDate(Date)
    
    case flightNumber(Int)
    case includeCodeshares(Bool)
    case includeEstimated(Bool)
    
    case cursor(String)
    case maxPages(Int)
}
