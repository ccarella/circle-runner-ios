//
//  ContentView.swift
//  CircleRunner
//
//  Created by Chris Carella on 8/4/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        GameView()
            .ignoresSafeArea()
    }
}

struct GameView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GameViewController {
        return GameViewController()
    }
    
    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        // No updates needed
    }
}

#Preview {
    ContentView()
}