import Foundation

#if !os(macOS)
extension Date {
    public static func day(_ day: Int,
                  of year: Int,
                  in timezone: TimeZone! = TimeZone(secondsFromGMT: 0)) throws -> (Date, Date) {
        var calendar = Calendar.current
        calendar.timeZone = timezone
        
        var startOfDay = DateComponents()
        startOfDay.year = year
        startOfDay.day = day
        startOfDay.hour = 0
        startOfDay.minute = 0
        
        guard let start = calendar.date(from: startOfDay)
        else { throw NSError() } // THROW: startDateCreationInvalid
        
        var endOfDay = DateComponents()
        endOfDay.year = year
        endOfDay.day = day + 1
        endOfDay.hour = 0
        endOfDay.minute = 0
        
        guard let end = calendar.date(from: endOfDay)
        else { throw NSError() } // THROW: endDateCreationInvalid
        
        return (start, end)
    }
    
    public func dayOfYear(in timezone: TimeZone! = TimeZone(secondsFromGMT: 0)) throws -> Int {
        var calendar = Calendar.current
        calendar.timeZone = timezone
        
        guard let day = calendar.ordinality(of: .day, in: .year, for: self)
        else { throw NSError() }
        return day
    }
    
    public func year(in timezone: TimeZone! = TimeZone(secondsFromGMT: 0)) throws -> Int {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.dateFormat = "yyyy"
        
        let string = formatter.string(from: self)
        guard let int = Int(string)
        else { throw NSError() }
        
        return int
    }
    
    
    /// Convert Date to the give string format
    /// - Parameters:
    ///   - format: String representation of date
    ///   - timeZone: TimeZone for requested date representation
    /// - Returns: Date represented as string for the Time Zone specified
    public func toFormat(_ format: String,
                      in timeZone: TimeZone! = .init(abbreviation: "GMT")) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }
}
#endif
