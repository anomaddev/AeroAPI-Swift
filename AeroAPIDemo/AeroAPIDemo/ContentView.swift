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
                let airportAwait = try await AeroAPI
                    .manager
                    .getAirportInfo(code: "92B")
                
                print(airportAwait.prettyJSON)
                print()
                
                AeroAPI.manager.getAirportInfo(iata: "LHR")
                { error, airport in
                    if let error = error
                    { error.explain(); return }
                    
                    guard let airport = airport
                    else { return }
                    
                    print(airport.prettyJSON)
                    print()
                }
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

extension Encodable {
    var prettyJSON: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self),
              let output = String(data: data, encoding: .utf8)
        else { return "Error converting \(self) to JSON string" }
        return output
    }
}
