import SwiftUI
import Combine

struct ContentView: View {

    //Store & select random number
    @State private var currentNumber: Int = Int.random(in: 1...200)

    @State private var correctCount: Int = 0
    @State private var wrongCount: Int = 0
    @State private var attemptCount: Int = 0
    
    //Did the user answer this round
    @State private var hasAnsweredThisRound: Bool = false
    
    //2 possible answers
    enum Choice {
        case prime
        case notPrime
    }
    @State private var userChoice: Choice? = nil //stores choice-  nil if nothing is selected.

    //show summary-  after every 10 attempts
    @State private var showSummaryAlert: Bool = false

    //create a timer that fires every 5 seconds
    private let timer = Timer.publish(
        every: 5.0,
        on: .main,
        in: .common //loops
    ).autoconnect() //autostarts

    //Styling 
    var body: some View {
        VStack(spacing: 28) {

            Text("Prime or Not?")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("\(currentNumber)")
                .font(.system(size: 72, weight: .heavy, design: .rounded))
                .padding(.vertical, 10)

            VStack(spacing: 16) {
                optionRow(title: "Prime", option: .prime, isCorrectOption: isPrime(currentNumber))
                optionRow(title: "Not Prime", option: .notPrime, isCorrectOption: !isPrime(currentNumber))
            }
            .padding(.horizontal, 24)

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
        .onReceive(timer) { _ in
            handleTimerTick()
        }
        .alert("Results after \(attemptCount) attempts", isPresented: $showSummaryAlert) {
            Button("OK") { }
        } message: {
            Text("Correct: \(correctCount)\nWrong: \(wrongCount)")
        }
    }

    private func optionRow(title: String, option: Choice, isCorrectOption: Bool) -> some View {
        Button {
            //runs when button is tapped 
            handleUserTap(option)
        } label: {
            HStack(spacing: 12) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()
                //show icons after answering
                if hasAnsweredThisRound {
                    if isCorrectOption {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.title2)
                    } else {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                            .font(.title2)
                    }
                }
            }
            .padding() 
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        //prevents tapping during the same round 
        .disabled(hasAnsweredThisRound)
    }
    //handles what users select
    private func handleUserTap(_ choice: Choice) {
        //stops user from being able to answer again
        guard !hasAnsweredThisRound else { return }

        userChoice = choice
        hasAnsweredThisRound = true
        
        //check if number is prime
        let numberIsPrime = isPrime(currentNumber)
        
        //check user choice 
        let userSaysPrime = (choice == .prime)

        if userSaysPrime == numberIsPrime {
            correctCount += 1
        } else {
            wrongCount += 1
        }

        recordAttemptAndMaybeShowSummary()
    }

    private func handleTimerTick() {
        if !hasAnsweredThisRound {
            wrongCount += 1
            recordAttemptAndMaybeShowSummary()
        }
        startNewRound()
    }

    private func startNewRound() {
        currentNumber = Int.random(in: 1...200)
        hasAnsweredThisRound = false
        userChoice = nil
    }

    private func recordAttemptAndMaybeShowSummary() {
        attemptCount += 1
        if attemptCount % 10 == 0 {
            showSummaryAlert = true
        }
    }

    private func isPrime(_ n: Int) -> Bool {
        if n < 2 { return false }
        if n == 2 { return true }
        if n % 2 == 0 { return false }

        let limit = Int(Double(n).squareRoot())
        var i = 3
        while i <= limit {
            if n % i == 0 { return false }
            i += 2
        }
        return true
    }
}

#Preview {
    ContentView()
}
   
    
    
    
    
    

