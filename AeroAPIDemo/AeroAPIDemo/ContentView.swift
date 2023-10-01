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
                    .getAirlineFlightCount(icao: "AAL")
                
                print(counts.prettyJSON)
                print()
            } catch { error.explain() }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .onViewDidLoad {
                
            }
    }
}
