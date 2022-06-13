//
//  ContentView.swift
//  Project2 - GuessTheFlag
//
//  Created by Vitali Vyucheiski on 6/1/22.
//

import SwiftUI

struct FlagButton: View {
    var image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var finaleAlert = false
    @State private var ScoreTitle = ""
    @State private var userScore = 0
    @State private var numberOfGuesses = 0
    
    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
//            RadialGradient(stops: [
//                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
//                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
//            ], center: .top, startRadius: 200, endRadius: 400)
//                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                      
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagButton(image: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(ScoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your Score is \(userScore)")
        }
        .alert("End", isPresented: $finaleAlert) {
            Button("Play Again", action: finals)
        } message: {
            Text("Your Final Score is \(userScore) out of 8")
        }
    }
    
    func flagTapped(_ number: Int){
        if number == correctAnswer {
            ScoreTitle = "Correct"
            userScore += 1
        } else {
            ScoreTitle = "Wrong! That’s the flag of \(countries[number])"
            
            if userScore > 0 {
                userScore -= 1
            }
        }
        numberOfGuesses += 1
        
        countries.remove(at: number)
        
        if numberOfGuesses == 8 {
            finaleAlert.toggle()
        } else {
            showingScore.toggle()
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func finals() {
        userScore = 0
        numberOfGuesses = 0
        countries = Self.allCountries.shuffled()
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12 Pro Max")
    }
}
