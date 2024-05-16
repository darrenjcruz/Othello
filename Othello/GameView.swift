//
//  GameView.swift
//  Othello
//
//  Created by Serafina Yu on 5/7/24.
//

import SwiftUI
import Foundation

// Enum to represent the state of each cell
enum CellState {
    case empty, p1, p2, pp1, pp2
}
// Enum to represent the winner
enum Winner {
    case w1, w2
}

struct Player {
    var name: String
    var score: Int
}

struct GameView: View {
    var AgainstAI: Bool
    var highScores: HighScore
    var p1name: String
    var p2name: String
    @State var player1: Player
    @State var player2: Player
    
    @State private var board: [[CellState]] = Array(repeating: Array(repeating: .empty, count: 8), count: 8)
    @State private var currentPlayer: CellState = .p1
    @State private var numPossibleMoves = 4
    @State private var gameOver = false
    @State private var winner = ""
    @State private var winnerScore = 0
    @State private var aiMoving = false
    @State private var showPossibleMoves = true
    
    
    @Environment(\.dismiss) var dismiss
    
    init(AgainstAI: Bool, highScores: HighScore, p1name: String, p2name: String) {
        self.AgainstAI = AgainstAI
        self.highScores = highScores
        self.p1name = p1name
        self.p2name = p2name
        self.player1 = Player(name: p1name, score: 2)
        self.player2 = Player(name: p2name, score: 2)
    }

    var body: some View {
        
        ZStack {
            // The blue background color
            Color(red: 0.172, green: 0.463, blue: 0.584)
            // VStack holds all the content of the game page
            VStack {
                Spacer()
                Spacer()
                Spacer()
                
                HStack {
                    Text("Turn: ")
                        .foregroundStyle(.white)
                        .font(.title)
                    Circle()
                        .foregroundColor(self.currentPlayer == .p1 ? Color(red: 0.129, green: 0.302, blue: 0.447) : .yellow)
                        .frame(width: 35, height: 35)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                // Game Board
                VStack {
                    ForEach(0..<8, id: \.self) { row in
                        HStack {
                            ForEach(0..<8, id: \.self) { col in
                                Button(action: {
                                    if !aiMoving {
                                        self.placePiece(row: row, col: col)
                                    }
                                }) {
                                    Circle()
                                        .foregroundColor(self.colorForCellState(self.board[row][col]))
                                        .opacity(self.circleOpacityForCellState(self.board[row][col]))
                                        .frame(width: 35, height: 35)
                                        .overlay(self.overlayForCellState(self.board[row][col]))

                                        
                                }
                                // Prevent players from placing their piece in a spot that is occupied
                                .disabled(aiMoving || self.board[row][col] == .p1 || self.board[row][col] == .p2)
                                .frame(width: 45, height: 45)
                                .border(Color.black)
                                .padding(-4)
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                }
                .padding(.vertical, 8)
                .border(Color.black, width:5)
                .background(Color(.white))
                .cornerRadius(5)
                .onAppear {
                            self.setupInitialBoardState()
                        }
            
                // Stack for player names and their piece color
                HStack {
                    Spacer()
                    Circle()
                        .foregroundColor(Color(red: 0.129, green: 0.302, blue: 0.447))
                        .frame(width: 35, height: 35)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                        )
                    Text(self.player1.name)
                        .foregroundStyle(.white)
                        .font(.title2)
                    Spacer()
                    Circle()
                        .foregroundColor(.yellow)
                        .frame(width: 35, height: 35)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                        )
                    Text(self.player2.name)
                        .foregroundStyle(.white)
                        .font(.title2)
                    Spacer()
                    
                }
                .padding(.top, 60)
                
                // Stack for players' score
                HStack {
                    Spacer()
                    Text("\(self.player1.score)")
                        .foregroundStyle(.white)
                        .font(.title2)
                        .padding(.trailing, 30)
                    Spacer()
                    Text("\(self.player2.score)")
                        .foregroundStyle(.white)
                        .font(.title2)
                    Spacer()
                }
                .padding(.top, 10)
                
                Spacer()
                
                HStack {
                    ForEach(0..<4) {_ in 
                        Spacer()
                    }
                    // Toggle button to show/hide possible moves
                    Toggle("Show Possible Moves?", isOn: $showPossibleMoves)
                        .foregroundColor(.white)
                        .padding()
                        .onChange(of: showPossibleMoves) { newValue in
                            // Call possibleMoves function when toggle state changes
                            possibleMoves()
                        }
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
            .padding(.horizontal, 10)
        }
        .ignoresSafeArea()
        .alert("Game Over!", isPresented: $gameOver) {
            Button("Play Again") {
                sendDataToRecords()
                resetGame()
            }
            
            NavigationLink(destination: ContentView().navigationBarHidden(true), label: {
                Text("Main Menu")
            })
            .onAppear{
                sendDataToRecords()
            }
        } message: {
            Text("\(self.winner) wins with a score of \(self.winnerScore)!")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ContentView().navigationBarHidden(true), label: {
                    Text("Quit")
                })
            }
        }
    }

    func setupInitialBoardState() {
        // Set initial pieces
        board[3][3] = .p2
        board[3][4] = .p1
        board[4][3] = .p1
        board[4][4] = .p2
        possibleMoves()
    }
    
    // Function to fill in cells with possible moves
    func possibleMoves() {
        // Remove all previous possible moves if toggle is off
        if !showPossibleMoves {
            for row in 0..<board.count {
                for col in 0..<board[row].count {
                    if board[row][col] == .pp1 || board[row][col] == .pp2 {
                        board[row][col] = .empty
                    }
                }
            }
            return // Don't continue further if we're hiding possible moves
        }
        
        // Remove all previous possible moves
        for row in 0..<board.count {
            for col in 0..<board[row].count {
                if board[row][col] == .pp1 || board[row][col] == .pp2 {
                    board[row][col] = .empty
                }
            }
        }
        // Set the # of possible moves to 0
        numPossibleMoves = 0
        
        // Set up all current moves
        for row in 0..<board.count {
                for col in 0..<board[row].count {
                    // If the cell is a valid move, change its state
                    if isValidMove(row: row, col: col) {
                        if currentPlayer == .p1 {
                            board[row][col] = .pp1
                        } else if currentPlayer == .p2 {
                            board[row][col] = .pp2
                        }
                        // Increment the possible moves by 1
                        numPossibleMoves += 1
                    }
                }
            }
    }
    
    // Function to place a piece at the specified row and column
    func placePiece(row: Int, col: Int) {
        if isValidMove(row: row, col: col) {
            // Place the current player's piece
            board[row][col] = currentPlayer
            
            // Iterate through all directions to check for flanking
            for dr in -1...1 {
                for dc in -1...1 {
                    // Skip the current cell and check the neighboring cells
                    if dr == 0 && dc == 0 { continue }
                    
                    // Check for flanking in this direction
                    if isFlanking(row: row, col: col, dRow: dr, dCol: dc) {
                        // Flip opponent's pieces in this direction
                        flipPieces(row: row, col: col, dRow: dr, dCol: dc)
                    }
                }
            }
            
            // Switch to the next player
            currentPlayer = (currentPlayer == .p1) ? .p2 : .p1
            
            // Update scores
            updateScores()
            
            // Update board to show new possible moves
            possibleMoves()
            
            // Check for win
            checkForWin()
            
            // Now, it's AI's turn
            if AgainstAI && currentPlayer == .p2 {
                // Delay AI's turn by 1 second
                aiMoving = true
                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 2...3)) {
                    makeAIMove()
                }
            }
        }
    }


    // Function to flip opponent's pieces in a specific direction
    func flipPieces(row: Int, col: Int, dRow: Int, dCol: Int) {
        var r = row + dRow
        var c = col + dCol
        
        // Move along the direction until a boundary or the same color is encountered
        while board[r][c] != currentPlayer {
            board[r][c] = currentPlayer
            r += dRow
            c += dCol
        }
    }

    // Function to update scores after placing a piece
    func updateScores() {
        var p1Count = 0
        var p2Count = 0
        for row in board {
            for cell in row {
                if cell == .p1 {
                    p1Count += 1
                } else if cell == .p2 {
                    p2Count += 1
                }
            }
        }
        player1.score = p1Count
        player2.score = p2Count
    }
    
    // Function to check if the move is valid
    // Takes the current cell and checks to see if its flanking
    func isValidMove(row: Int, col: Int) -> Bool {
        // Check if the cell is empty, pp1, or pp2
        if board[row][col] == .empty || board[row][col] == .pp1 || board[row][col] == .pp2 {
            // Iterate through all directions to check for flanking
            for dr in -1...1 {
                for dc in -1...1 {
                    // Skip the current cell and check the neighboring cells
                    if dr == 0 && dc == 0 { continue }

                    // Check for flanking in this direction
                    if isFlanking(row: row, col: col, dRow: dr, dCol: dc) {
                        return true
                    }
                }
            }
        }
        return false
    }

    // Function to check if there is flanking in a specific direction
    func isFlanking(row: Int, col: Int, dRow: Int, dCol: Int) -> Bool {
       var r = row + dRow
       var c = col + dCol
       var hasOpponentPiece = false

       // Move along the direction until a boundary or the same color is encountered
       while r >= 0 && r < 8 && c >= 0 && c < 8 {
           let state = board[r][c]
           if state == currentPlayer {
               // Found a piece of the current player, so flanking is successful
               return hasOpponentPiece
           } else if state == .empty || state == .pp1 || state == .pp2 {
               // Found an empty cell, so no flanking
               return false
           } else {
               // Found an opponent's piece, continue checking in this direction
               hasOpponentPiece = true
           }
           r += dRow
           c += dCol
       }

       // Reached the boundary, so no flanking
       return false
   }
    
    // Function to check if the game is over
    func checkForWin() {
        // If there are no possible moves left, the game is over
        if numPossibleMoves == 0 {
            // If there are any leftover empty slots, fill them in with the next players pieces
            flipLeftoverPieces()
            updateScores()
            setWinner()
            gameOver = true
        } else {
            gameOver = false
        }
    }
    
    func makeAIMove() {
        let possibleMovesList = generatePossibleMoves()
        if !possibleMovesList.isEmpty {
            // Choose a random move from the list of possible moves
            let randomIndex = Int.random(in: 0..<possibleMovesList.count)
            let (row, col) = possibleMovesList[randomIndex]
            board[row][col] = currentPlayer
            
            // Iterate through all directions to check for flanking
            for dr in -1...1 {
                for dc in -1...1 {
                    // Skip the current cell and check the neighboring cells
                    if dr == 0 && dc == 0 { continue }
                    
                    // Check for flanking in this direction
                    if isFlanking(row: row, col: col, dRow: dr, dCol: dc) {
                        // Flip opponent's pieces in this direction
                        flipPieces(row: row, col: col, dRow: dr, dCol: dc)
                    }
                }
            }
            checkForWin()
            aiMoving = false
            currentPlayer = (currentPlayer == .p1) ? .p2 : .p1
            possibleMoves()
        }
    }
    
    func generatePossibleMoves() -> [(Int, Int)] {
        var moves = [(Int, Int)]()
        for row in 0..<board.count {
            for col in 0..<board[row].count {
                if isValidMove(row: row, col: col) {
                    moves.append((row, col))
                }
            }
        }
        return moves
    }
    
    // Function to set the winner
    func setWinner() {
        if player1.score > player2.score {
            winner = player1.name
            winnerScore = player1.score
        } else {
            winner = player2.name
            winnerScore = player2.score
        }
    }
    
    // Function to send game data to records
    func sendDataToRecords() {
        let score = HighScoreItem(name: winner, score: winnerScore)
        let _ = print(score)
        highScores.scores.append(score)
    }
    
    // Function to change leftover empty pieces to the next player's pieces if the current player has no more moves left
    func flipLeftoverPieces() {
        // If the current player is p1, change every empty tile to p2's pieces
        if currentPlayer == .p1 {
            for row in 0..<board.count {
                for col in 0..<board[row].count {
                    if board[row][col] == .empty {
                        board[row][col] = .p2
                    }
                }
            }
        // If the current player is p2, change every empty tile to p1's pieces
        } else {
            for row in 0..<board.count {
                for col in 0..<board[row].count {
                    if board[row][col] == .empty {
                        board[row][col] = .p1
                    }
                }
            }
        }
    }
    
    func resetGame() {
        self.board = Array(repeating: Array(repeating: .empty, count: 8), count: 8)
        self.currentPlayer = .p1
        self.numPossibleMoves = 4
        self.gameOver = false
        self.winner = ""
        self.winnerScore = 0
        self.player1.score = 2
        self.player2.score = 2
        setupInitialBoardState()
    }
    
    // Function to determine the color of the cell based on its state
    func colorForCellState(_ state: CellState) -> Color {
        switch state {
        case .p1:
            return Color(red: 0.129, green: 0.302, blue: 0.447)
        case .p2:
            return .yellow
        case .pp1:
            return Color(red: 0.13, green: 0.2, blue: 0.45)
        case .pp2:
            return Color(red: 0.97, green: 0.76, blue: 0.2)
        default:
            return .white // Empty cell color
        }
    }
    
    // Function to determine whether the circle should have a border
    func overlayForCellState(_ state: CellState) -> some View {
        if state == .p1 || state == .p2 {
            return Circle().stroke(Color.black, style: StrokeStyle(lineWidth: 1))
        } else if state == .pp1 || state == .pp2 {
            return Circle().stroke(Color.black, style: StrokeStyle(lineWidth: 1, dash: [5]))
        } else {
            return Circle().stroke(Color.clear, style: StrokeStyle(lineWidth: 0))
        }
    }
    
    // Function to set opacity
    func circleOpacityForCellState(_ state: CellState) -> Double {
        switch state {
        case .pp1, .pp2:
            return 0.5 // Set opacity to 50% for .pp1 and .pp2 states
        default:
            return 1.0 // Default opacity for other states
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(AgainstAI: true, highScores: HighScore(), p1name: "DJ", p2name: "AI")
    }
}
