//
//  RecordsView.swift
//  Othello
//
//  Created by DJ Cruz on 5/8/24.
//

import SwiftUI

struct RecordsView: View {
    var highScores: HighScore
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Section(header: Text("High Score").padding(.bottom, 5)) {
                    ForEach(highScores.scores) { highScore in
                        HStack {
                            Text(highScore.name)
                            Spacer()
                            Text("\(highScore.score)")
                        }
                        .padding()
                        .background(Color(red: 33/255, green: 77/255, blue: 114/255))
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(Color(red: 0.172, green: 0.463, blue: 0.584))
        .navigationTitle("Records")
        .toolbarBackground(Color(red: 0.172, green: 0.463, blue: 0.584), for: .navigationBar, .tabBar)
    }
}

#Preview {
    RecordsView(highScores: HighScore())
}
