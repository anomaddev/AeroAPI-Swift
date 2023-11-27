//
//  FlightStatus.swift
//  
//
//  Created by Justin Ackermann on 11/23/22.
//

import UIKit

// TODO: More detailed status handling

public enum FlightStatus: String, Codable, CaseIterable {
    
    static var base: UIColor = UIColor(
        _colorLiteralRed: 47/255,
        green: 47/255,
        blue: 47/255,
        alpha: 1
    )
    
    static var success: UIColor = UIColor(
        _colorLiteralRed: 13/255,
        green: 165/255,
        blue: 28/255,
        alpha: 1
    )
    
    static var error: UIColor = UIColor(
        _colorLiteralRed: 196/255,
        green: 25/255,
        blue: 48/255,
        alpha: 1
    )
    
    static var warning: UIColor = UIColor(
        _colorLiteralRed: 196/255,
        green: 25/255,
        blue: 48/255,
        alpha: 1
    )
    
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
    
    public var color: UIColor {
        switch self {
        case .Scheduled, 
             .Unknown,
             .ResultUnknown:
            return Self.base
            
        case .OnTime,
                .EnrouteOnTime,
                .EnRoute,
                .Taxiing,
                .LandedTaxiing,
                .LeftGate,
                .Arrived,
                .GateArrival:
            return Self.success
            
        case .Delayed,
                .EnrouteDelayed,
                .DelayedArrival,
                .TaxxingDelayed,
                .ScheduledDelay: 
            return Self.warning
            
        case .Cancelled,
                .Diverted,
                .ReturnedToGate: 
            return Self.error
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

