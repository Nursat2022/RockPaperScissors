//
//  ContentView.swift
//  RockPaperScissorsApp
//
//  Created by Nursat Sakyshev on 14.04.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isPlaying = false
    
    var body: some View {
        NavigationView {
            VStack {
                WelcomePage(isPlaying: $isPlaying)
                NavigationLink(isActive: $isPlaying) {
                    takeYourPickSingle()
                } label: {}
            }
        }
        takeYourPickSingle()
    }
}

struct WelcomePage: View {
    @Binding var isPlaying: Bool
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
                
                numberOfPlayers(isPlaying: $isPlaying, players: "Single player")
                numberOfPlayers(isPlaying: $isPlaying, players: "Multi player")
            }
            .padding(.top, 120)
            .padding(.bottom, 40)
        }
    }
}

struct headerText: View {
    @Binding var color: [Color]
    @Binding var text: String
    var body: some View {
        Text(text)
            .gradientForeground(colors: color)
            .font(.system(size: 54))
            .multilineTextAlignment(.center)
            .fontWeight(.bold)
    }
}

struct takeYourPickSingle: View {
    var playerPick = "Your pick"
    var takeYourPick = "Take your pick"
    var thinking = "Your\n opponent is\n thinking"
    var oponentPick = "Your opponent’s pick"
    @State private var header = "Take your pick"
    @State private var loadOrPick = "loading"
    @State private var result = "Tie!"
    @State private var changed = false
    @State private var selectedPaper = false
    @State private var selectedScissors = false
    @State private var selectedRock = false
    @State private var selected = false
    @State private var next = false
    @State private var showScore = true
    @State private var buttonWidth = 348
    @State private var offsetX1: CGFloat = 0
    @State private var offsetY1: CGFloat = 0
    @State private var offsetX2: CGFloat = UIScreen.main.bounds.width
    @State private var offsetY2: CGFloat = 0
    @State private var color: [Color] = [.black]
    @State private var anotherRound = false
    var loseColor = [Color(red: 255/255, green: 105/255, blue: 97/255), Color(red: 253/255, green: 77/255, blue: 77/255)]
    var winColor = [Color(red: 181/255, green: 238/255, blue: 155/255), Color(red: 36/255, green: 174/255, blue: 67/255)]
    var tieColor = [Color(red: 255/255, green: 204/255, blue: 0/255), Color(red: 255/255, green: 92/255, blue: 0/255)]
    
    var body: some View {
        ZStack {
            VStack(spacing: 74) {
                VStack(spacing: 12) {
                    headerText(color: $color, text: $header)
                    
                    if showScore {
                        Text("Score 0:0")
                            .foregroundColor(Color(red: 103/255, green: 80/255, blue: 164/255))
                    }
                }
                
                VStack(spacing: 24) {
                    if !selected || selectedPaper {
                        choiceButton(isSelected: $selectedPaper, selected: $selected, image: "paper")
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    if !selected || selectedScissors {
                        choiceButton(isSelected: $selectedScissors, selected: $selected, image: "scissors")
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    if !selected || selectedRock {
                        choiceButton(isSelected: $selectedRock, selected: $selected, image: "rock")
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    if next {
                        ZStack {
                            loadOrPickImage(imageName: $loadOrPick, offsetX: $offsetX1, offsetY: $offsetY1)
                                .onAppear {
                                    if loadOrPick == "loading" {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            withAnimation {
                                                header = oponentPick
                                                loadOrPick = "paper"
                                            }
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                            withAnimation(.spring()) {
                                                header = ""
                                                offsetY1 = -80
                                                offsetX1 = -70
                                            }
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                            withAnimation(.spring()) {
                                                header = result
                                                showScore = true
                                                anotherRound = true
                                                color = loseColor
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom, 55)
                            
                            loadOrPickImage(imageName: $loadOrPick, offsetX: $offsetX2, offsetY: $offsetY2)
                                .onAppear {
                                    if loadOrPick == "loading" {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            withAnimation {
                                                header = oponentPick
                                                loadOrPick = "paper"
                                            }
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                            withAnimation(.spring()) {
                                                offsetY2 = -10
                                                offsetX2 = 70
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom, 55)
                            
                            if anotherRound {
                                withAnimation {
                                    VStack {
                                        Spacer()
                                        changeOrNext(changeView: $changed, text: "Another round")
                                    }
                                    .padding(.top, 500)
                                }
                            }
                        }
                    }
                }
                .frame(height: 432)
                
            }
            //            .padding(.vertical, 120)
            .frame(height: UIScreen.main.bounds.height)
            .navigationTitle("Round #1")
            
            VStack {
                Spacer()
                if selected && !next {
                    changeOrNext(changeView: $changed, text: "I changed my mind")
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    changeOrNext(changeView: $next, text: "Next")
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.bottom, 60)
        }
        .padding(.vertical, 120)
        
        .onChange(of: changed) { newValue in
            if changed {
                withAnimation {
                    changed = false
                    selectedPaper = false
                    selectedScissors = false
                    selectedRock = false
                    selected = false
                    next = false
                    showScore = true
                    header = takeYourPick
                }
            }
        }
        
        .onChange(of: next) { newValue in
            if next {
                withAnimation {
                    changed = false
                    selectedPaper = false
                    selectedScissors = false
                    selectedRock = false
                    selected = true
                    showScore = false
                    header = thinking
                }
            }
        }
        
        .onChange(of: selected) { newValue in
            withAnimation {
                if selected {
                    header = playerPick
                }
            }
        }
    }
   
}

struct loadOrPickImage: View {
    @Binding var imageName: String
    @State var Width: CGFloat = 348
    @Binding var offsetX: CGFloat
    @Binding var offsetY: CGFloat
    var smallWidth = 198
    var body: some View {
        RoundedRectangle(cornerRadius: 48)
            .fill(Color(red: 243/255, green: 242/255, blue: 248/255))
            .frame(width: Width, height: 128)
            .overlay {
                Image(imageName)
                    .frame(width: 40, height: 40)
                    RoundedRectangle(cornerRadius: 48)
                    .stroke(Color.white, lineWidth: 10)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    Width = 198
                }
            }
            .offset(x: offsetX, y: offsetY)
            .animation(.spring())
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
    @Binding var isSelected: Bool
    @Binding var selected: Bool
    var image: String
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                isSelected = true
                selected = true
            }
        }) {
            Image(image)
                .frame(width: 294, height: 80)
        }
        .padding(24)
        .background(Color(red: 243/255, green: 242/255, blue: 248/255))
        .cornerRadius(47)
    }
}

struct numberOfPlayers: View {
    @Binding var isPlaying: Bool
    var players: String
    var body: some View {
        Button(action: {
            isPlaying = true
        }) {
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

struct changeOrNext: View {
    @Binding var changeView: Bool
    var text: String
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                changeView = true
            }
        }) {
            Text(text)
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


struct opponentPick: View {
    var body: some View {
        VStack {
            VStack(spacing: 136) {
                Text("Your opponent’s pick")
                    .foregroundColor(.black)
                    .font(.system(size: 54))
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                
//                                choiceButton(isSelected: false, image: "scissors")
            }
            
            Spacer()
        }
        .padding(.top, 120)
        .ignoresSafeArea()
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
                //                choiceButton(image: "scissors")
            }
            
            Spacer()
            //            numberOfPlayers(players: "I changed my mind")
        }
        .padding(.top, 120)
        .padding(.bottom, 40)
        .ignoresSafeArea()
    }
}
