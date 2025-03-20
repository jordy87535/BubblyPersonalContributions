//
//  RoundBreakdownView.swift
//  Bubbly
//
//  Created by Jordan Becker on 11/21/23.
//

import SwiftUI

struct RoundBreakdownView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: GameViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 64) {
                Text("Round Breakdown")
                    .font(.system(size: 50, design: .rounded))
                    .bold()

                ForEach(vm.game.roundBreakdownSummary) { roundBreakdown in
                    RoundBreakdownEntryView(roundBreakdown: roundBreakdown)
                }

                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    let game = Game()
    let gameViewModel = GameViewModel(game: game)
    game.status = .completed
    game.rounds.append(Game.Round(word: Word("Bubbly", wordList: Word.WordList.kSightWord), choices: ["round", "breakdown"]))
    return RoundBreakdownView(vm: gameViewModel)
}
