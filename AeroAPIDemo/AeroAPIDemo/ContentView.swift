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
                let track = try await AeroAPI
                    .manager
                    .getTrack(
                        faId: "AAL1722-1695242173-airline-4780p"
                    )
                
                print(track.prettyJSON)
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
