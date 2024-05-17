//
//  PlayerNameView.swift
//  Othello
//
//  Created by Darren Cruz & Serafina Yu on 5/7/24.
//

import SwiftUI
import Foundation

struct PlayerNameView: View {
    var AgainstAI: Bool
    var highScores: HighScore
    
    @State private var p1Name = ""
    @State private var p2Name = ""
    
    var body: some View {
        Form {
            Section("**Player 1's Name:**") {
                TextField("Please enter a name...", text: $p1Name)
            }
            .headerProminence(.increased)
            .foregroundColor(Color(red: 29.0/255.0, green: 55.0/255.0, blue: 82.0/255.0))
            
            if AgainstAI == false {
                Section("**Player 2's Name:**") {
                    TextField("Please enter a name...", text: $p2Name)
                }
                .headerProminence(.increased)
                .foregroundColor(Color(red: 29.0/255.0, green: 55.0/255.0, blue: 82.0/255.0))
            }
            
            Section {
                NavigationLink(destination: AgainstAI ? GameView(AgainstAI: AgainstAI, highScores: highScores, p1name: p1Name, p2name: "AI") : GameView(AgainstAI: AgainstAI, highScores: highScores, p1name: p1Name, p2name: p2Name)
                        
                ){
                    Text("Continue")
                }
            }
            .disabled(!isValid())
        }
        .navigationTitle("Game Details")
        .background(Color(red: 0.172, green: 0.463, blue: 0.584))
        .scrollContentBackground(.hidden)
    }
    
    func isValid() -> Bool {
        if AgainstAI == true {
            let trimmedp1Name = p1Name.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedp1Name.isEmpty {
                return false
            } else {
                return true
            }
        } else {
            let trimmedp1Name = p1Name.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedp2Name = p2Name.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedp1Name.isEmpty || trimmedp2Name.isEmpty {
                return false
            } else {
                return true
            }
        }
    }
}

#Preview {
    PlayerNameView(AgainstAI: true, highScores: HighScore())
}
