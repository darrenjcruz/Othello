//
//  PlayerNameView.swift
//  Othello
//
//  Created by Serafina Yu on 5/7/24.
//

import SwiftUI
import Foundation

struct PlayerNameView: View {
    @State private var p1Name = ""
    
    var body: some View {
        VStack {
            Section {
                Text("Player 1's Name:")
                TextField("Please enter a name...", text: $p1Name)
            }
        }
    }
    
}

#Preview {
    PlayerNameView()
}
