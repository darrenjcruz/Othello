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
            if let decodedItems = try?
                JSONDecoder().decode([HighScoreItem].self, from: savedHighScores) {
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

enum ViewIdentifier: Hashable {
    case playerNameView, howToPlayView, recordsView, gameView
}
struct ContentView: View {
    @State private var highScores = HighScore()
    @State private var navigationPath = NavigationPath() // Use programmatic navigation to handle navigation destinations
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color(red: 0.172, green: 0.463, blue: 0.584)
                    .ignoresSafeArea()
                
                VStack {
                    Image("OthelloLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 150)
                        .foregroundStyle(.tint)
                        .padding(.bottom, 75)
                    
                    NavigationLink(destination: PlayerNameView(AgainstAI: true, highScores: highScores)) { // but AI
                        Text("Player Vs. AI")
                    }
                    .buttonStyle(TealButton())
                    .padding(.bottom, 25)
                                  
                    NavigationLink(destination: PlayerNameView(AgainstAI: false, highScores: highScores)) {
                        Text("Player Vs. Player")
                    }
                    .buttonStyle(TealButton())
                    .padding(.bottom, 25)
                    
                    NavigationLink(destination: HowToPlayView()) {
                        Text("How To Play")
                    }
                    .buttonStyle(TealButton())
                    .padding(.bottom, 25)
                    
                    NavigationLink(destination: RecordsView(highScores: highScores)) {
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
