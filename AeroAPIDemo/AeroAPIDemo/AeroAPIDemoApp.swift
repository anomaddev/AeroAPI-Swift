//
//  AeroAPIDemoApp.swift
//  AeroAPIDemo
//
//  Created by Justin Ackermann on 9/26/23.
//

import SwiftUI

@main
struct AeroAPIDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// NOMADUI:
extension View {
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
    }
}

struct ViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad = false
    let action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}
