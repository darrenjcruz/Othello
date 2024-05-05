import SwiftUI
import Foundation

// Enum to represent the state of each cell
enum CellState {
    case empty, p1, p2
}

struct GameView: View {
    @State private var board: [[CellState]] = Array(repeating: Array(repeating: .empty, count: 8), count: 8)
    @State private var currentPlayer: CellState = .p1
    @State private var p1Score = 2 // Initial score for player 1
    @State private var p2Score = 2 // Initial score for player 2
    @State private var possibleMovesArray: [(row: Int, col: Int)] = []


    var body: some View {
        ZStack {
            // The blue background color
            Color(red: 0.172, green: 0.463, blue: 0.584)
            // VStack holds all the content of the game page
            VStack {
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
                                    self.placePiece(row: row, col: col)
                                }) {
                                    Circle()
                                        .foregroundColor(self.colorForCellState(self.board[row][col]))
                                        .frame(width: 35, height: 35)
                                        .overlay(self.overlayForCellState(self.board[row][col]))

                                        
                                }
                                // Prevent players from placing their piece in a spot that is occupied
                                .disabled(self.board[row][col] != .empty)
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
            
                HStack {
                    Spacer()
                    Circle()
                        .foregroundColor(Color(red: 0.129, green: 0.302, blue: 0.447))
                        .frame(width: 35, height: 35)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                        )
                    Text("Player 1")
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
                    Text("Player 2")
                        .foregroundStyle(.white)
                        .font(.title2)
                    Spacer()
                    
                }
                .padding(.top, 60)
                
                HStack {
                    Spacer()
                    Text("\(p1Score)")
                        .foregroundStyle(.white)
                        .font(.title2)
                        .padding(.trailing, 30)
                    Spacer()
                    Text("\(p2Score)")
                        .foregroundStyle(.white)
                        .font(.title2)
                    Spacer()
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(.horizontal, 10)
        }
        .ignoresSafeArea()
    }

    func setupInitialBoardState() {
        // Set initial pieces
        board[3][3] = .p2
        board[3][4] = .p1
        board[4][3] = .p1
        board[4][4] = .p2
    }
    
    func possibleMoves() {
        // Fill in cells with possible moves
        
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
        }
        
        // Update scores
        updateScores()
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
                    let _ = print("player 1: \(p1Count)")
                } else if cell == .p2 {
                    p2Count += 1
                    let _ = print("player 2: \(p2Count)")
                }
            }
        }
        p1Score = p1Count
        p2Score = p2Count
    }
    
    // Function to check if the move is valid
    func isValidMove(row: Int, col: Int) -> Bool {
        // Check if the cell is empty
        guard board[row][col] == .empty else { return false }

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

        return false
//        return true
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
           } else if state == .empty {
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
    
    // Function to determine the color of the cell based on its state
    func colorForCellState(_ state: CellState) -> Color {
        switch state {
        case .p1:
            return Color(red: 0.129, green: 0.302, blue: 0.447)
        case .p2:
            return .yellow
        default:
            return .white // Empty cell color
        }
    }
    
    // Function to determine whether the circle should have a border
    func overlayForCellState(_ state: CellState) -> some View {
        if state == .p1 || state == .p2 {
            return Circle().stroke(Color.black, lineWidth: 1)
        } else {
            return Circle().stroke(Color.clear, lineWidth: 0)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
