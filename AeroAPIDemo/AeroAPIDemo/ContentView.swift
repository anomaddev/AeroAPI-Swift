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
                let counts = try await AeroAPI
                    .manager
                    .getAirportFlightCounts(code: "KTPA")
                
                print(counts.prettyJSON)
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
