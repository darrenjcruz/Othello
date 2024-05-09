//
//  ContentView.swift
//  Othello
//
//  Created by DJ Cruz on 5/1/24.
//

import SwiftUI
import Observation

struct HighScoreItem: Identifiable, Codable, Comparable {
    var id = UUID()
    let name: String
    let score: Int
    
    static func <(lhs: HighScoreItem, rhs: HighScoreItem) -> Bool {
        lhs.score < rhs.score
    }
}

@Observable
class HighScore {
    init() {
        if let savedHighScores = UserDefaults.standard.data(forKey: "HighScores") {
            if let decodedItems = try? JSONDecoder().decode([HighScoreItem].self, from: savedHighScores) {
                scores = decodedItems
                return
            }
        }
        
        scores = []
    }
    
    var scores = [HighScoreItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(scores) {
                UserDefaults.standard.set(encoded, forKey: "HighScores")
            }
        }
    }
}

struct TealButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 33.0/255.0, green: 77.0/255.0, blue: 114.0/255.0))
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}

struct ContentView: View {
    @State private var highScores = HighScore()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.172, green: 0.463, blue: 0.584)
                    .ignoresSafeArea()
                
                VStack {
                    Image("OthelloLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .foregroundStyle(.tint)
                    
                    NavigationLink {
                        GameView(highScores: highScores) // but AI
                    } label: {
                        Text("Player Vs. AI")
                    }
                    .buttonStyle(TealButton())
                    
                    NavigationLink {
                        GameView(highScores: highScores)
                    } label: {
                        Text("Player Vs. Player")
                    }
                    .buttonStyle(TealButton())
                    
                    NavigationLink {
                        HowToPlayView()
                    } label: {
                        Text("How To Play")
                    }
                    .buttonStyle(TealButton())
                    
                    NavigationLink {
                        RecordsView(highScores: highScores)
                        let _ = print(highScores)
                    } label: {
                        Text("Records")
                    }
                    .buttonStyle(TealButton())
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
