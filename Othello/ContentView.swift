//
//  ContentView.swift
//  Othello
//
//  Created by DJ Cruz on 5/1/24.
//

import SwiftUI

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
                        GameView() // but AI
                    } label: {
                        Text("Player Vs. AI")
                    }
                    .buttonStyle(TealButton())
                    
                    NavigationLink {
                        //GameView() but two player
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
                        //RecordsView
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
