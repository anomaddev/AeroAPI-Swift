import Foundation

#if !os(macOS)

/// Errors for the AeroAPI
public enum AeroAPIError: Error {
    
    /// API key is not set
    case apiKeyNotSet
    
    /// No FlightAware ID for flight
    case noFaId
    
    /// Could not generate URL from components of AeroAPIRequest
    case invalidURLFromComponents
    
    // Date errors
    /// start date for search cannot be completed
    case startDateCreationInvalid
    
    /// end date for search cannot be completed
    case endDateCreationInvalid
    
    // Flight Track errors
    /// flight track response is empty
    case flightTrackEmpty
    
    // Decoder errors
    /// failed to decode ScheduledFlightResponse
    case failedDecodingScheduledFlightResponse
    /// failed to decode FlightDataResponse
    case failedDecodingFlightDataResponse
    /// failed to decode FlightTrackResponse
    case failedDecodingFlightTrackResponse
    
    /// Generic error
    case fall
    
    /// Throw in all other cases
    case unexpected(code: Int)
}

extension AeroAPIError: CustomStringConvertible {
    public var description: String {
        switch self {
            
        case .apiKeyNotSet:
            return "No API Key set for the AeroAPI module."
            
        case .noFaId:
            return "No faId found for this scheduled flight."
            
        case .invalidURLFromComponents:
            return "Could not generate URL from components of AeroAPIRequest."
            
        case .startDateCreationInvalid:
            return "Failed to create start date using calendar"
            
        case .endDateCreationInvalid:
            return "Failed to create end date using calendar"
            
        case .failedDecodingScheduledFlightResponse:
            return "Failed to decode the ScheduledFlightResponse"
            
        case .failedDecodingFlightDataResponse:
            return "Failed to decode the FlightDataResponse"
            
        // MARK: - desc,FlightTrack
        case .flightTrackEmpty:
            return "Flight Track response is empty"
            
        case .failedDecodingFlightTrackResponse:
            return "Failed to decode the FlightTrackResponse"
         
        // MARK: - desc,Generic
        case .fall:
            return "An ignorable generic error occured."
            
        case .unexpected(_):
            return "An unexpected error occurred."
        }
    }
}

extension AeroAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            
        case .apiKeyNotSet:
            return NSLocalizedString(
                "API Key is not set for the AeroAPI module.",
                comment: "No AeroAPI key set"
            )
            
        case .noFaId:
            return NSLocalizedString(
                "No faId is posted for this scheduled flight.",
                comment: "No FaId"
            )
            
        case .invalidURLFromComponents:
            return NSLocalizedString(
                "URL Components for AeroAPIRequest are invalid",
                comment: "URL Invalid"
            )
            
        case .startDateCreationInvalid:
            return NSLocalizedString(
                "Failed to create start date in day range extension",
                comment: "failed date creation"
            )
            
        case .endDateCreationInvalid:
            return NSLocalizedString(
                "Failed to create end date in day range extension",
                comment: "failed date creation"
            )
            
        case .failedDecodingScheduledFlightResponse:
            return NSLocalizedString(
                "Failed to decode ScheduledFlightResponse",
                comment: "failed decoding"
            )
            
        case .failedDecodingFlightDataResponse:
            return NSLocalizedString(
                "Failed to decode FlightDataResponse",
                comment: "failed decoding"
            )
            
        // MARK: - errorDesc,FlightTrack
        case .flightTrackEmpty:
            return NSLocalizedString(
                "FlightTrackResponse is empty with no positions",
                comment: "no positions returned"
            )
            
        case .failedDecodingFlightTrackResponse:
            return NSLocalizedString(
                "Failed to decode FlightTrackResponse",
                comment: "failed decoding"
            )
            
        // MARK: - errorDesc,Generic
        case .fall:
            return NSLocalizedString(
                "An ignorable generic error occured.",
                comment: "Ignorable Errror"
            )
        
        case .unexpected(_):
            return "An unexpected error occurred."
        }
    }
}
#endif
