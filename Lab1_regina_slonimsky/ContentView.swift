import SwiftUI
internal import Combine

struct ContentView: View {

    // MARK: - Game State
    @State private var currentNumber: Int = Int.random(in: 1...200)

    @State private var correctCount: Int = 0
    @State private var wrongCount: Int = 0
    @State private var attemptCount: Int = 0

    // Tracks whether the user answered within the current 5-second window
    @State private var hasAnsweredThisRound: Bool = false

    // Tracks what the user picked (nil means they haven’t tapped yet)
    enum Choice {
        case prime
        case notPrime
    }
    @State private var userChoice: Choice? = nil

    // Summary alert every 10 attempts
    @State private var showSummaryAlert: Bool = false

    // MARK: - Timer (fires every 5 seconds)
    private let timer = Timer.publish(every: 5.0, on: .main, in: .common).autoconnect()

    var body: some View {
        //styling
        VStack(spacing: 28) {

            Text("Prime or Not?")
                .font(.largeTitle)
                .fontWeight(.bold)

            // random number
            Text("\(currentNumber)")
                .font(.system(size: 72, weight: .heavy, design: .rounded))
                .padding(.vertical, 10)

            // Buttons area
            VStack(spacing: 16) {
                optionRow(
                    title: "Prime",
                    option: .prime,
                    isCorrectOption: isPrime(currentNumber)
                )

                optionRow(
                    title: "Not Prime",
                    option: .notPrime,
                    isCorrectOption: !isPrime(currentNumber)
                )
            }
            .padding(.horizontal, 24)

            // Scoreboard
            VStack(spacing: 8) {
                Text("Attempts: \(attemptCount)")
                Text("Correct: \(correctCount)")
                Text("Wrong: \(wrongCount)")
            }
            .font(.headline)
            .padding(.top, 10)

            Spacer()
        }
        .padding()
        // Timer logic: every 5 seconds, check if user answered. If not, wrong++.
        .onReceive(timer) { _ in
            handleTimerTick()
        }
        .alert("Results after \(attemptCount) attempts", isPresented: $showSummaryAlert) {
            Button("OK") { }
        } message: {
            Text("Correct: \(correctCount)\nWrong: \(wrongCount)")
        }
    }
    
    // UI for an option row (Prime / Not Prime)
    private func optionRow(title: String, option: Choice, isCorrectOption: Bool) -> some View {
        Button {
            handleUserTap(option)
        } label: {
            HStack(spacing: 12) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Show icons only after the user answers this round
                if hasAnsweredThisRound {
                    // Green check appears on the correct option
                    if isCorrectOption {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.title2)
                    } else {
                        // Red cross appears on the wrong option
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                            .font(.title2)
                    }
                }
            }
            padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.secondarySystemBackground))
                )
        }
        // Disable taps after they answered 
        .disabled(hasAnsweredThisRound)
    }
    //  When user taps Prime / Not Prime
    private func handleUserTap(_ choice: Choice) {
        guard !hasAnsweredThisRound else { return }

        userChoice = choice
        hasAnsweredThisRound = true

        let numberIsPrime = isPrime(currentNumber)
        let userSaysPrime = (choice == .prime)

        if userSaysPrime == numberIsPrime {
            correctCount += 1
        } else {
            wrongCount += 1
        }

        recordAttemptAndMaybeShowSummary()
        
        }
    // Every 5 seconds (timer tick)
    private func handleTimerTick() {
        // If user didn't answer in time, count as wrong
        if !hasAnsweredThisRound {
            wrongCount += 1
            recordAttemptAndMaybeShowSummary()
            }

            // Start a new round
            startNewRound()
        }

    
}

   
    
    
    
    
    

