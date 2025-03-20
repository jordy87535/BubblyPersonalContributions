//
//  GameSummaryView.swift
//  Bubbly
//
//  Created by Jordan Becker on 9/26/23.
//

import SwiftUI

struct GameSummaryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: GameViewModel
    @ObservedObject var game: Game
    
    var body: some View {
        VStack {
            topBar
                .padding(.bottom)
            ScrollView {
                VStack(alignment: .center) {
                    correctHeader
                        .padding()
                    HStack(alignment: .top) {
                        neverMissedArray
                        needsWorkArray
                    }
                }
            }
            .padding(.horizontal, 64)
            footer
        }
        .padding()
    }
    
    /// Returns display name of word list for current round
    private var titleBuilder: String {
        guard let firstRoundWordList = game.rounds.first?.word.wordList.shortenedCategoryString else {
            return "Empty Word List"
        }
        for round in game.rounds {
            if round.word.wordList.shortenedCategoryString != firstRoundWordList {
                return "Custom Word List"
            }
        }
        return firstRoundWordList
    }
    
    /// Display round correctness view without taking number of tries into account
    @ViewBuilder
    private var correctHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Correct:")
                .font(.system(size: 40))
                .foregroundColor(Color("Green"))
                .fontWeight(.bold)
            Text("\(game.numCorrectRounds)/\(game.numTotalRounds) Rounds")
                .font(.system(size: 30))
                .fontWeight(.semibold)
            correctProgressBar
        }
    }
    
    /// Display the letters/words that the user got right on the first try
    @ViewBuilder
    private var neverMissedArray: some View {
        VStack(alignment: .leading) {
            Text("Never Missed")
                .font(.system(size: 40))
                .foregroundColor(Color("Green"))
                .fontWeight(.bold)
            Text("Correct on 1st attempt")
                .font(.system(size: 30))
                .fontWeight(.semibold)
            WrappingHStackBuilder(models: game.neverMissed)
        }
        .padding()
    }
    
    /// Display the letters/words that the user got incorrect on the first try
    @ViewBuilder
    private var needsWorkArray: some View {
        VStack(alignment: .leading) {
            Text("Needs Work")
                .font(.system(size: 40))
                .fontWeight(.bold)
                .foregroundColor(Color("IgnoreContrastRed"))
            Text("Incorrect on 1st attempt")
                .font(.system(size: 30))
                .fontWeight(.semibold)
            WrappingHStackBuilder(models: game.needsWork)
        }
        .padding()
    }
    
    /// Display the play again and round breakdown buttons
    @ViewBuilder
    private var footer: some View {
        let labelFont: CGFloat = 28
        let labelForegroundColor = Color.white
        let labelPadding: CGFloat = 20
        let labelCornerRadius: CGFloat = 14
        
        HStack {
            Button(action: {
                vm.playAgain()
            }) {
                Label {
                    Text("Play Round Again")
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .padding(labelPadding)
                } icon: {
                    Image(systemName: "play.fill")
                        .padding(.leading)
                }
                .font(.system(size: labelFont))
                .foregroundColor(labelForegroundColor)
                .background(Color("Green"))
                .cornerRadius(labelCornerRadius)
            }
            .padding(.horizontal)
            NavigationLink(destination: RoundBreakdownView(vm: vm)) {
                Label {
                    Text("Round Breakdown").fontWeight(.semibold)
                        .padding(labelPadding)
                } icon: {
                    Image(systemName: "list.clipboard")
                        .padding(.leading)
                }
                .font(.system(size: labelFont))
                .foregroundColor(labelForegroundColor)
                .background(Color.secondary)
                .cornerRadius(labelCornerRadius)
            }
        }
    }
   
    /// Button to take user back to homepage
    @ViewBuilder
    private var homeButton: some View {
        NavigationLink(destination: HomeView()) {
            Image(systemName: "house.fill")
                .resizable()
                .frame(width: 87, height: 75)
                .font(.largeTitle)
                .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    private var summaryBar: some View {
        Text("Summary of \(titleBuilder)")
            .fontWeight(.bold)
            .font(.system(size: 50))
            .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    private var topBar: some View {
        HStack(alignment: .top, spacing: 24) {
            Spacer()
            homeButton
        }
        .overlay(summaryBar, alignment: .center)
    }
    
    /// Builds the progress bar for the round correctness view
    @ViewBuilder
    private var correctProgressBar: some View {
        @State var correctRounds = Float(game.numCorrectRounds)
        @State var totalRounds = Float(game.numTotalRounds)
        ProgressView(value: correctRounds, total: totalRounds)
            .progressViewStyle(MyProgressViewStyle())
    }
    
    struct MyProgressViewStyle: ProgressViewStyle {
        func makeBody(configuration: Configuration) -> some View {
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundColor(Color("Divider"))
                    
                    RoundedRectangle(cornerRadius: 14)
                        .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * proxy.size.width)
                        .foregroundColor(Color("Green"))
                }
            }
            .frame(height: 16)
        }
    }
    
    /// View to populate neverMissed and needsWorks arrays
    struct AccuracyArrayWordView: View {
        var word: Word
        var color: Color? = Color.blue
        
        var body: some View {
            Text(word.text)
                .lineLimit(1)
                .fontWeight(.semibold)
                .font(.system(size: 32))
                .foregroundColor(.white)
                .padding(4)
                .padding(.horizontal)
                .background(color)
                .cornerRadius(8)
        }
    }
    
    struct WrappingHStackBuilder: View {
        var models: [Word]
        
        var body: some View {
            WrappingHStack(models: models, viewGenerator: { word in
                AccuracyArrayWordView(word: word, color: word.wordList.primaryColor)
            }, horizontalSpacing: 6, verticalSpacing: 4)
        }
    }
}

#Preview {
    let game = Game()
    let gameViewModel = GameViewModel(game: game)
    game.status = .completed
    game.rounds.append(Game.Round(word: Word("Bubbly", wordList: Word.WordList.kSightWord), choices: ["oh", "no"]))
    return GameSummaryView(vm: gameViewModel, game: game)
}
