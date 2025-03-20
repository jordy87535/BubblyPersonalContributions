//
//  RoundBreakdownEntryView.swift
//  Bubbly
//
//  Created by Jordan Becker on 1/29/24.
//

import SwiftUI

struct RoundBreakdownEntryView: View {
    let roundBreakdown: RoundBreakdown

    var body: some View {
        VStack(spacing: 0) {
            roundInfoView
            divider
            answerChoicesView
            divider
            attemptsView
        }
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(25)
        .padding(.horizontal, 200)
    }

    /// Returns overall correctness of round
    @ViewBuilder
    private var roundInfoView: some View {
        HStack {
            Text("Round \(roundBreakdown.roundNumber): ")
                + Text(roundBreakdown.isCorrect ? "Correct" : "Incorrect")
                .foregroundColor(roundBreakdown.isCorrect ? .green : .red)
        }
        .font(.system(size: 50, weight: .bold, design: .rounded))
        .padding()
    }

    /// Returns all answer choices and their respective correctness
    @ViewBuilder
    private var answerChoicesView: some View {
        HStack (alignment: .center) {
              Text("Answer Choices: ")
                  .bold()
                  .lineLimit(1)
                  .padding()

              WrappingHStack(
                  models: roundBreakdown.allChoices,
                  viewGenerator: { choice in
                      choiceConvertor(choice: choice)
                          .bold()
                  },
                  horizontalSpacing: 10,
                  verticalSpacing: 5
              )
          }
          .padding(.horizontal)
          .font(.system(size: 28, design: .rounded))
    }

    /// Returns attempt number that user got answer correct on
    @ViewBuilder
    private var attemptsView: some View {
        HStack {
            Text("Answered correct on ").bold()
                + Text(roundBreakdown.attempts.asOrdinal).underline().bold()
                + Text(" attempt").bold()
        }
        .font(.system(size: 24, design: .rounded))
        .padding()
    }

    @ViewBuilder
    private var divider: some View {
        Rectangle()
            .fill(Color("Divider"))
            .frame(width: 350, height: 2, alignment: .center)
    }

    /// Returns answer choice with text color and underline attributes based on correctness
    private func choiceConvertor(choice: String) -> Text {
        let concatenatedChoice: String
        if choice.count <= 11 {
            concatenatedChoice = choice
        } else {
            concatenatedChoice = String(choice.prefix(11)) + "..."
        }

        if roundBreakdown.correctChoice == choice {
            return Text(concatenatedChoice)
                .accessibilityLabel("\(choice) is correct")
                .foregroundColor(.green)
                .underline(true)
        } else if roundBreakdown.incorrectGuesses.contains(choice) {
            return Text(concatenatedChoice)
                .accessibilityLabel("\(choice) is incorrect")
                .foregroundColor(.red)
                .underline(false)
        } else {
            return Text(concatenatedChoice)
                .foregroundColor(.primary)
                .underline(false)
        }
    }
}

extension Int {
    var asOrdinal: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

#Preview {
    let roundbreakdown = RoundBreakdown(roundNumber: 1, isCorrect: true, allChoices: ["round", "breakdown"], correctChoice: "round", incorrectGuesses: ["breakdown"], attempts: 2)
    return RoundBreakdownEntryView(roundBreakdown: roundbreakdown)
}
