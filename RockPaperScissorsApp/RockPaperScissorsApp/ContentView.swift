//
//  ContentView.swift
//  RockPaperScissorsApp
//
//  Created by Nursat Sakyshev on 14.04.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Result(title: "Tie!", color: [Color(red: 255/255, green: 204/255, blue: 0/255), Color(red: 255/255, green: 92/255, blue: 0/255)])
    }
}

struct WelcomePage: View {
    var body: some View {
        ZStack {
            Image("BackgroundImage")
            VStack {
                Text("Welcome to the game!")
                    .foregroundColor(.white)
                    .font(.system(size: 54))
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                
                Spacer()
                
                numberOfPlayers(players: "Single player")
                numberOfPlayers(players: "Multi player")
            }
            .padding(.top, 122)
            .padding(.bottom, 40)
        }
    }
}

struct takeYourPick: View {
    var body: some View {
        VStack(spacing: 74) {
            VStack(spacing: 12) {
                Text("Take your pick")
                    .foregroundColor(.black)
                    .font(.system(size: 54))
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                
                Text("Score 0:0")
                    .foregroundColor(Color(red: 103/255, green: 80/255, blue: 164/255))
            }
            
            VStack(spacing: 24) {
                choiceButton(image: "paper")
                choiceButton(image: "scissors")
                choiceButton(image: "rock")
            }
        }
    }
}

struct YourPick: View {
    var body: some View {
        VStack {
            VStack(spacing: 12) {
                Text("Your pick")
                    .foregroundColor(.black)
                    .font(.system(size: 54))
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                
                Text("Score 0:0")
                    .foregroundColor(Color(red: 103/255, green: 80/255, blue: 164/255))
            }
            
            Spacer(minLength: 226)
            
            VStack {
                choiceButton(image: "scissors")
            }
            
            Spacer()
            numberOfPlayers(players: "I changed my mind")
        }
        .padding(.top, 120)
        .padding(.bottom, 40)
        .ignoresSafeArea()
    }
}

struct opponentPick: View {
    var body: some View {
        VStack {
            VStack(spacing: 136) {
                Text("Your opponent’s pick")
                    .foregroundColor(.black)
                    .font(.system(size: 54))
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                
                choiceButton(image: "scissors")
            }

            Spacer()
        }
        .padding(.top, 120)
        .ignoresSafeArea()
    }
}

struct Result: View {
    var title: String
    var color: [Color]
    var body: some View {
        VStack {
            VStack(spacing: 12) {
                Text(title)
                    .gradientForeground(colors: color)
                    .font(.system(size: 54))
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                
                Text("Score 0:0")
                    .foregroundColor(Color(red: 103/255, green: 80/255, blue: 164/255))
                
                HStack {
                    RoundedRectangle(cornerRadius: 48)
                        .frame(width: 198, height: 128)
                        .foregroundColor(Color(red: 243/255, green: 242/255, blue: 248/255))
                    
                        .overlay {
                            Image("scissors")
                                .frame(width: 80, height: 80)
                        }
                    
                    RoundedRectangle(cornerRadius: 48)
                        .frame(width: 190, height: 128)
                        .foregroundColor(Color(red: 243/255, green: 242/255, blue: 248/255))
                    
                        .overlay {
                            Image("rock")
                                .frame(width: 80, height: 80)
                        }
                        .offset(x: -60)
                }
            }
        }
    }
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
        )
        .mask(self)
    }
}

struct choiceButton: View {
    var image: String
    var body: some View {
        Button(action: {}) {
            Image(image)
                .frame(width: 294, height: 80)
        }
        .padding(24)
        .background(Color(red: 243/255, green: 242/255, blue: 248/255))
        .cornerRadius(47)
    }
}

struct numberOfPlayers: View {
    var players: String
    var body: some View {
        Button(action: {}) {
            Text(players)
                .fontWeight(.semibold)
                .frame(width: 295, height: 22)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 31.5)
        .padding(.vertical, 14)
        .background(Color(red: 103/255, green: 80/255, blue: 164/255))
        .cornerRadius(8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
