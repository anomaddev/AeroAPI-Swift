import Foundation

public protocol AeroAPIRequest: Codable {
    var filters: [RequestFilters] { get set }
    
    func path() throws -> String
    func request() throws -> [URLQueryItem]
}

public struct CursorRequest: AeroAPIRequest {
    public func path() throws -> String
    { return cursor }
    
    public var cursor: String
    public var filters: [RequestFilters]
    
    init(cursor: String) {
        self.cursor = cursor
        self.filters = []
    }
}

public extension AeroAPIRequest {
    func request() throws -> [URLQueryItem] {
        return self.filters.compactMap { filter -> URLQueryItem in
            switch filter {
            case .ident(let ident):
                return URLQueryItem(name: "ident", value: ident)
                
            case .identType(let type):
                return URLQueryItem(name: "ident_type", value: type.rawValue)
                
            case .airportIDType(let type):
                return URLQueryItem(name: "id_type", value: type.rawValue)
                
            case .airline(let airline):
                return URLQueryItem(name: "airline", value: airline)
                
            case .origin(let origin):
                return URLQueryItem(name: "origin", value: origin)
                
            case .destination(let dest):
                return URLQueryItem(name: "destination", value: dest)
                
            case .latitude(let lat):
                return URLQueryItem(name: "latitude", value: "\(lat)")
                
            case .longitude(let lng):
                return URLQueryItem(name: "longitude", value: "\(lng)")
                
            case .countryCode(let code):
                return URLQueryItem(name: "country_code", value: code)
                
            case .timestamp(let stamp):
                return URLQueryItem(name: "timestamp", value: stamp.toFormat(AeroAPI.dateStringFormat))
                
            case .startDate(let start):
                return URLQueryItem(name: "start", value: start.toFormat(AeroAPI.dateStringFormat))
                
            case .endDate(let end):
                return URLQueryItem(name: "end", value: end.toFormat(AeroAPI.dateStringFormat))
                
            case .disruptionTimePeriod(let time):
                return URLQueryItem(name: "time_period", value: time.rawValue)
                
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
                
            case .airportFlightType(let type):
                return URLQueryItem(name: "type", value: "\(type.rawValue)")
                
            case .connectionType(let type):
                return URLQueryItem(name: "connection", value: "\(type.rawValue)")
                
            case .radius(let radius):
                return URLQueryItem(name: "radius", value: "\(radius)")
                
            case .onlyInstuments(let onlyIAP):
                return URLQueryItem(name: "only_iap", value: "\(onlyIAP)")
                
            case .returnNearbyWeather(let bool):
                return URLQueryItem(name: "return_nearby_weather", value: "\(bool)")
                
            case .routeSortBy(let sort):
                return URLQueryItem(name: "sort_by", value: sort.rawValue)
                
            case .maxFileAge(let max):
                return URLQueryItem(name: "max_file_age", value: max)
                
            case .temperatureUnits(let units):
                return URLQueryItem(name: "temperature_units", value: units.rawValue)
            }
        }
    }
}

public enum RequestFilters: Codable {
    case ident(String)
    case identType(IdentType)
    case airportIDType(AirportIDType)
    
    case airline(String)
    case origin(String)
    case destination(String)
    case latitude(Double)
    case longitude(Double)
    case countryCode(String)
    
    case timestamp(Date)
    case startDate(Date)
    case endDate(Date)
    case disruptionTimePeriod(DisruptionCountTimePeriod)
    
    case flightNumber(Int)
    case includeCodeshares(Bool)
    case includeEstimated(Bool)
    
    case cursor(String)
    case maxPages(Int)
    
    case airportFlightType(FlightType)
    case connectionType(FlightConnectionType)
    case radius(Int)
    case onlyInstuments(Bool)
    
    case returnNearbyWeather(Bool)
    case routeSortBy(RouteRequestSort)
    case maxFileAge(String)
    case temperatureUnits(TemperatureUnits)
}

public enum IdentType: String, Codable {
    case designator
    case faId = "fa_flight_id"
    case registration
}
