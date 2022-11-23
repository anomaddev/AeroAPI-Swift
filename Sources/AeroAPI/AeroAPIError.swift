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
    
    // Decoder errors
    /// failed to decode ScheduledFlightResponse
    case failedDecodingScheduledFlightResponse
    case failedDecodingFlightDataResponse
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
            
        case .failedDecodingScheduledFlightResponse:
            return "Failed to decode the ScheduledFlightResponse"
            
        case .failedDecodingFlightDataResponse:
            return "Failed to decode the FlightDataResponse"
            
        case .failedDecodingFlightTrackResponse:
            return "Failed to decode the FlightTrackResponse"
            
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
            
        case .failedDecodingFlightTrackResponse:
            return NSLocalizedString(
                "Failed to decode FlightTrackResponse",
                comment: "failed decoding"
            )
            
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
