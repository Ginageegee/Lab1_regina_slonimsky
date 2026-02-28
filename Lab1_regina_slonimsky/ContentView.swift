//
//  ContentView.swift
//  Lab1_regina_slonimsky
//
//  Created by Gina Slonimsky  on 2026-02-27.
//

import SwiftUI
internal import Combine

struct ContentView: View {
    
    @State private var currentNumber: Int = Int.random(in: 1...200)
    
    @State private var correctCount: Int = 0
    @State private var wrongCount: Int = 0
    @State private var attemptCount: Int = 0
    
    // Tracks whether the user answered within 5 seconds
    @State private var hasAnsweredThisRound: Bool = false
    
    // Tracks what the user picked
    enum Choice {
        case prime
        case notPrime
    }
    
    @State private var userChoice: Choice? = nil
    
    // Summary every 10 attempts
    @State private var showSummaryAlert: Bool = false
    
    // Timer
    private let timer = Timer.publish(every: 5.0, on: .main, in: .common).autoconnect()
}
