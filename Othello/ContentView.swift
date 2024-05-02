//
//  ContentView.swift
//  Othello
//
//  Created by DJ Cruz on 5/1/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "face.smiling")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("DJ can you see this?")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
