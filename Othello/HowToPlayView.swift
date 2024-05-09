//
//  HowToPlayView.swift
//  Othello
//
//  Created by DJ Cruz on 5/4/24.
//

import SwiftUI

struct HowToPlayView: View {
    var body: some View {
        ZStack {
            Color(red: 0.172, green: 0.463, blue: 0.584)
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack {
                    Image("OthelloLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 150)
                        .foregroundStyle(.tint)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    Text("How to Play")
                        .font(.largeTitle)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    Text("Goal:")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Text("Players take turns placing a piece of their own color on the board that allows them to flip their opponent's pieces into their own color. The player with the most pieces on the board wins.")
                        .font(.body)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    Text("Rules:")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Text("The game is played on an 8 x 8 game board in which the 4 center squares are ocupied by alternating colored pieces. Traditionally the lighter colored piece is in the top left center corner and the player with the darker pieces go first.")
                        .font(.body)
                    
                    Spacer()
                    Spacer()
                    
                    Image("StartingBoard")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .foregroundStyle(.tint)
                    
                    Spacer()
                    Spacer()
                    
                    Text("Players are only allowed to place a piece if there exists at least one piece of the opposite color placed in between the current piece and a previous piece. The pieces must be in a continuous line, whether it is horizontal, vertical or diagonal. Possible moves for both darker pieces and lighter pieces are shown on their respective turns as transparent.")
                        .font(.body)
                    
                    Spacer()
                    
                    HStack {
                        Image("BluePossibleMoves")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 200)
                            .foregroundStyle(.tint)
                        
                        Image("YellowPossibleMoves")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 200)
                            .foregroundStyle(.tint)
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Text("The game continues until current player cannot make a valid move or the board is filled. The following image on the left shows a game in which it is the dark player's turn and they cannot make a valid move. The image on the right shows a game in which the board has been filled.")
                        .font(.body)
                    
                    Spacer()
                    
                    HStack {
                        Image("NoPossibleMoves")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 200)
                            .foregroundStyle(.tint)
                        
                        Image("BoardFilled")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 200)
                            .foregroundStyle(.tint)
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Text("The winner is chosen by who ever has the most pieces on the board. The winner's name and score will be recorded. The person who has the most wins, most wins against the AI and their highest score against AI can be found on the Records screen.")
                }
                .padding()
                .frame(alignment: .center)
            }
            .frame(maxWidth: .infinity)
            .navigationTitle("How to Play")
            .toolbarBackground(Color(red: 0.172, green: 0.463, blue: 0.584), for: .navigationBar, .tabBar)
        }
    }
}

#Preview {
    HowToPlayView()
}
