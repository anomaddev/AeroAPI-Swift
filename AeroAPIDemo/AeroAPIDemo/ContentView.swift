//
//  ContentView.swift
//  AeroAPIDemo
//
//  Created by Justin Ackermann on 9/26/23.
//

import SwiftUI
import AeroAPI
import NomadUtilities

struct ContentView: View {
    var body: some View {
        VStack {
            
        }
        .task {
            do {
                let request = try AirportFlightsRequest(
                    code: "KJFK",
                    dateRange: (
                        start: Date(seconds: 1695587773),
                        end: Date(seconds: 1695587773 + 86400)
                    ),
                    requestType: .departures
                )
                
                let flights = try await AeroAPI
                    .manager
                    .getAirportsFlights(request: request)
                
                print(flights.prettyJSON)
                print()
            } catch { error.explain() }
        }
    }
    
    init() {
        AeroAPI.manager.set(apiKey: "DKRlkQdGkuUtTYvf9sNbX7MO4X5leRKN")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .onViewDidLoad {
                
            }
    }
}
