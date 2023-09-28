import Foundation

/// Errors for the AeroAPI
public enum AeroAPIError: Error {
    
    /// API key is not set
    case apiKeyNotSet
    
    /// No FlightAware ID for flight
    case noFaId
    
    /// Could not generate URL from components of AeroAPIRequest
    case invalidURLFromComponents
    
    /// When the HTTP response errors present the code
    case HTTPResponseError(_ code: Int?)
    
    /// When the HTTP response is 200, but no data was returned
    case noDataReturnedForValidStatusCode
    
    
    // Data errors
    /// no errors were thrown but no flight data was returned either
    case noFlightDataForValidRequest
    
    /// no errors were thrown but no flight track data was returned either
    case noFlightTrackDataForValidRequest
    
    
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
            
        case .HTTPResponseError(let code):
            return "HTTP Response Error Code: \(code ?? 9999)"
            
        case .noDataReturnedForValidStatusCode:
            return "The HTTP Response was 200 but we did not return any data."
            
        case .noFlightDataForValidRequest:
            return "No flight data was returned for a request that returned no error."
            
        case .noFlightTrackDataForValidRequest:
            return "No flight track data was returned for a request that returned no error."
            
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
            
        case .unexpected(let code):
            return "An unexpected error occurred: \(code)"
        }
    }
}

extension AeroAPIError: LocalizedError {
    public var errorDescription: String? {
        var key: String = ""
        switch self {
            
        case .apiKeyNotSet:
            key = "apiKeyNotSet"
        
        case .noFaId:
            key = "noFaId"
        
        case .invalidURLFromComponents:
            key = "invalidURLFromComponents"
            
        case .HTTPResponseError:
            key = "HTTPResponseError"
            
        case .noDataReturnedForValidStatusCode:
            key = "noDataReturnedForValidStatusCode"
            
        case .noFlightDataForValidRequest:
            key = "noFlightDataForValidRequest"
            
        case .noFlightTrackDataForValidRequest:
            key = "noFlightTrackDataForValidRequest"
        
        case .startDateCreationInvalid:
            key = "startDateCreationInvalid"
        
        case .endDateCreationInvalid:
            key = "endDateCreationInvalid"
        
        case .failedDecodingScheduledFlightResponse:
            key = "failedDecodingScheduledFlightResponse"
        
        case .failedDecodingFlightDataResponse:
            key = "failedDecodingFlightDataResponse"
            
        // MARK: - errorDesc,FlightTrack
        case .flightTrackEmpty:
            key = "flightTrackEmpty"
            
        case .failedDecodingFlightTrackResponse:
            key = "failedDecodingFlightTrackResponse"
            
        // MARK: - errorDesc,Generic
        case .fall:
            key = "fall"
        
        case .unexpected:
            key = "unexpected"
        }
        
        return NSLocalizedString(
            key,
            comment: self.description
        )
    }
}
