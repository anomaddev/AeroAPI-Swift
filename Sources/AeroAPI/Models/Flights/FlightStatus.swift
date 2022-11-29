//
//  FlightStatus.swift
//  
//
//  Created by Justin Ackermann on 11/23/22.
//

import UIKit

// TODO: More detailed status handling

public enum FlightStatus: String, Codable, CaseIterable {
    
    // Diverted
    case Diverted
    case ReturnedToGate = "Returned to Gate"
    
    // Arrived
    case Arrived
    case GateArrival = "Arrived / Gate Arrival"
    case DelayedArrival = "Arrived / Delayed"
    
    // Taxi
    case LeftGate = "Left Gate"
    case Taxiing = "Taxiing / Left Gate"
    case TaxxingDelayed = "Taxiing / Delayed"
    case LandedTaxiing = "Landed / Taxiing"
    
    // Inflight
    case OnTime
    case Delayed
    case EnRoute
    case EnrouteOnTime = "En Route / On Time"
    case EnrouteDelayed = "En Route / Delayed"
    
    // Base
    case Scheduled
    case Unknown
    case ResultUnknown = "result unknown"
    case Cancelled
    
    case ScheduledDelay = "Scheduled / Delayed"
    
    public var hasArrived: Bool {
        switch self {
        case .GateArrival,
            .DelayedArrival,
            .Arrived: return true
        default: return false
        }
    }
    
    public var isTaxiing: Bool {
        switch self {
        case .Taxiing,
            .TaxxingDelayed,
            .LandedTaxiing,
            .LeftGate: return true
        default: return false
        }
    }
    
    public var isInflight: Bool {
        switch self {
        case .OnTime,
            .EnRoute,
            .EnrouteOnTime,
            .EnrouteDelayed,
            .Delayed: return true
        default: return false
        }
    }
    
    public var isDelayed: Bool {
        switch self {
        case .Delayed,
            .EnrouteDelayed,
            .DelayedArrival,
            .TaxxingDelayed,
            .ScheduledDelay: return true
        default: return false
        }
    }
    
    public var hasDiverted: Bool {
        switch self {
        case .Diverted,
            .ReturnedToGate: return true
        default: return false
        }
    }
    
    public var label: String {
        switch self {
        case .Scheduled: return "Scheduled"
            
        case .Arrived,
            .GateArrival,
            .DelayedArrival: return "Arrived"
            
        case .OnTime,
            .EnrouteOnTime,
            .EnRoute: return "On Time"
            
        case .Taxiing,
            .TaxxingDelayed,
            .LeftGate,
            .LandedTaxiing: return "Taxiing"
            
        case .Delayed,
            .EnrouteDelayed,
            .ScheduledDelay: return "Delayed"
            
        case .Cancelled: return "Cancelled"
        case .Diverted: return "Diverted"
        case .ReturnedToGate: return "Return to Gate"
        case .Unknown, .ResultUnknown: return "Status Unknown"
        }
    }
}

