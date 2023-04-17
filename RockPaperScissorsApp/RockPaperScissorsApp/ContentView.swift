//
//  ContentView.swift
//  RockPaperScissorsApp
//
//  Created by Nursat Sakyshev on 14.04.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isPlayingSingle = false
    @State private var isPlayingMultiple = false
    
    var body: some View {
        NavigationView {
            VStack {
                WelcomePage(isPlayingSingle: $isPlayingSingle, isPlayingMultiple: $isPlayingMultiple)
                NavigationLink(isActive: $isPlayingSingle) {
                    SinglePlayer()
                } label: {}
                
                NavigationLink(isActive: $isPlayingMultiple) {
                    MultiplePlayer()
                } label: {}
            }
        }
    }
}

struct WelcomePage: View {
    @Binding var isPlayingSingle: Bool
    @Binding var isPlayingMultiple: Bool
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
                
                BottomButton(text: "Single player") {
                    isPlayingSingle = true
                }
                BottomButton(text: "Multi player") {
                    isPlayingMultiple = true
                }
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

struct SinglePlayer: View {
    
    func defaultSettings() {
//        header = "Take your pick"
//        loadOrPick = "loading"
        changed = false
        selectedPaper = false
        selectedScissors = false
        selectedRock = false
        selected = false
        next = false
//        showScore = true
        offsetX1 = 0
        offsetY1 = 0
//        offsetX2 = UIScreen.main.bounds.width
//        offsetY2 = 0
//        color = [.black]
//        anotherRound = false
    }
    
    var playerPick = "Your pick"
    var takeYourPick = "Take your pick"
    var thinking = "Your\n opponent is\n thinking"
    var oponentPick = "Your opponent’s pick"
    @State private var header = "Take your pick"
    @State private var loadOrPick = "loading"
    @State private var changed = false
    @State private var selectedPaper = false
    @State private var selectedScissors = false
    @State private var selectedRock = false
    @State private var selected = false
    @State private var next = false
    @State private var showScore = true
    @State private var offsetX1: CGFloat = 0
    @State private var offsetY1: CGFloat = 0
    @State private var offsetX2: CGFloat = UIScreen.main.bounds.width
    @State private var offsetY2: CGFloat = 0
    @State private var color: [Color] = [.black]
    @State private var anotherRound = false
    @State private var playerChoice = ""
    @State private var oponentChoice = ""
    var loseColor = [Color(red: 255/255, green: 105/255, blue: 97/255), Color(red: 253/255, green: 77/255, blue: 77/255)]
    var winColor = [Color(red: 181/255, green: 238/255, blue: 155/255), Color(red: 36/255, green: 174/255, blue: 67/255)]
    var tieColor = [Color(red: 255/255, green: 204/255, blue: 0/255), Color(red: 255/255, green: 92/255, blue: 0/255)]
    
    var player = Player(name: "Player", choice: .paper)
    var oponent = Player(name: "Computer", choice: .rock)
    
    var body: some View {
        ZStack {
            VStack(spacing: 74) {
                VStack(spacing: 12) {
                    headerText(color: $color, text: $header)
                    
                    if showScore {
                        Text("Score \(player.score):\(oponent.score)")
                            .foregroundColor(Color(red: 103/255, green: 80/255, blue: 164/255))
                    }
                }
                
                VStack(spacing: 24) {
                    if !selected || selectedPaper {
                        choiceButtonSingle(isSelected: $selectedPaper, selected: $selected, choice: $playerChoice, oponentChoice: $oponentChoice, image: "paper")
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    if !selected || selectedScissors {
                        choiceButtonSingle(isSelected: $selectedScissors, selected: $selected, choice: $playerChoice, oponentChoice: $oponentChoice, image: "scissors")
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    if !selected || selectedRock {
                        choiceButtonSingle(isSelected: $selectedRock, selected: $selected, choice: $playerChoice, oponentChoice: $oponentChoice, image: "rock")
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    if next {
                        ZStack {
                            loadOrPickImage(seconds: 4, imageName: $loadOrPick, offsetX: $offsetX1, offsetY: $offsetY1)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            header = oponentPick
                                            loadOrPick = oponent.choice.rawValue
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
                                            showScore = true
                                            anotherRound = true
                                            switch player.status {
                                            case .win:
                                                header = "Win!"
                                                color = winColor
                                            case .lose:
                                                header = "Lose"
                                                color = loseColor
                                            case .tie:
                                                header = "Tie!"
                                                color = tieColor
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom, 55)
                            
                            loadOrPickImage(seconds: 4, imageName: $playerChoice, offsetX: $offsetX2, offsetY: $offsetY2)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                        withAnimation(.spring()) {
                                            offsetY2 = -10
                                            offsetX2 = 70
                                        }
                                    }
                                }
                                .padding(.bottom, 55)
                            
                            if anotherRound {
                                withAnimation {
                                    VStack {
                                        Spacer()
                                        BottomButton(text: "Another round", action: defaultSettings)
                                    }
                                    .padding(.top, 500)
                                }
                            }
                        }
                    }
                }
                .frame(height: 432)
                
            }
            .frame(height: UIScreen.main.bounds.height)
            .navigationTitle("Round #1")
            
            VStack {
                Spacer()
                if selected && !next {
                    BottomButton(text: "I changed my mind", action: {
                        changed = true
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                    BottomButton(text: "Next", action: {
                        next = true
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.bottom, 60)
        }
        .padding(.vertical, 120)
        
        .onChange(of: oponentChoice, perform: { _ in
            switch oponentChoice {
            case "paper": oponent.choice = .paper
            case "rock": oponent.choice = .rock
            case "scissors": oponent.choice = .scissors
            default:
                break
            }
        })
        
        .onChange(of: playerChoice, perform: { _ in
            switch playerChoice {
            case "paper": player.choice = .paper
            case "rock": player.choice = .rock
            case "scissors": player.choice = .scissors
            default:
                break
            }
        })
        
        .onChange(of: changed) { _ in
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
                print("changed")
            }
        }
        
        .onChange(of: next) { _ in
            if next {
                withAnimation {
                    changed = false
                    selectedPaper = false
                    selectedScissors = false
                    selectedRock = false
                    selected = true
                    showScore = false
                    header = thinking
                    print("next true")

                }
                player.play(player2: oponent)
            }
            print("next false")
        }
        
        .onChange(of: selected) { _ in
            withAnimation {
                if selected {
                    header = playerPick
                }
            }
            print("selected")
        }
    }
}

struct MultiplePlayer: View {
    func defaultSettings() {
        header = "Take your pick"
        loadOrPick = "loading"
        changed = false
        selectedPaper = false
        selectedScissors = false
        selectedRock = false
        selected = false
        next = false
        showScore = true
        offsetX1 = 0
        offsetY1 = 0
        offsetX2 = UIScreen.main.bounds.width
        offsetY2 = 0
        color = [.black]
        anotherRound = false
        player1Choice = ""
        player2Choice = ""
        player1.status = .tie
        player2.status = .tie
        currentPlayer = "Player1"
        start = true
    }
    
    var playerPick = "Your pick"
    var takeYourPick = "Take your pick"
    var thinking = "Your\n opponent is\n thinking"
    var oponentPick = "Your opponent’s pick"
    @State private var start = true
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
    @State private var player1Choice = ""
    @State private var player2Choice = ""
    var loseColor = [Color(red: 255/255, green: 105/255, blue: 97/255), Color(red: 253/255, green: 77/255, blue: 77/255)]
    var winColor = [Color(red: 181/255, green: 238/255, blue: 155/255), Color(red: 36/255, green: 174/255, blue: 67/255)]
    var tieColor = [Color(red: 255/255, green: 204/255, blue: 0/255), Color(red: 255/255, green: 92/255, blue: 0/255)]
    
    var player1 = Player(name: "Player1", choice: .paper)
    var player2 = Player(name: "Player2", choice: .rock)
    @State var currentPlayer = "Player1"
    
    var body: some View {
        ZStack {
            VStack(spacing: 74) {
                VStack(spacing: 12) {
                    headerText(color: $color, text: $header)
                    
                    if showScore {
                        Text("\(currentPlayer) · Score \(player1.score):\(player2.score)")
                            .foregroundColor(Color(red: 103/255, green: 80/255, blue: 164/255))
                    }
                }
                
                VStack(spacing: 24) {
                    if !selected || selectedPaper {
                        choiceButtonMultiple(isSelected: $selectedPaper, selected: $selected, choice: currentPlayer == "Player1" ? $player1Choice : $player2Choice, image: "paper")
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    if !selected || selectedScissors {
                        choiceButtonMultiple(isSelected: $selectedScissors, selected: $selected, choice: currentPlayer == "Player1" ? $player1Choice : $player2Choice, image: "scissors")
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    if !selected || selectedRock {
                        choiceButtonMultiple(isSelected: $selectedRock, selected: $selected, choice: currentPlayer == "Player1" ? $player1Choice : $player2Choice, image: "rock")
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    if next {
                        if currentPlayer == "Player1" {
                            VStack {
                                Spacer()
                                BottomButton(text: "ready to continue") {
                                    currentPlayer = "Player2"
                                }
                            }
                            .padding(.top, 390)
                        }
                        else if currentPlayer == "Player2" && player2Choice != "" {
                            ZStack {
                                loadOrPickImage(seconds: 2, imageName: $player2Choice, offsetX: $offsetX1, offsetY: $offsetY1)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            withAnimation(.spring()) {
                                                header = ""
                                                offsetY1 = -80
                                                offsetX1 = -70
                                            }
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                            withAnimation(.spring()) {
                                                showScore = true
                                                anotherRound = true
                                                switch player2.status {
                                                case .win:
                                                    header = "Win!"
                                                    color = winColor
                                                case .lose:
                                                    header = "Lose"
                                                    color = loseColor
                                                case .tie:
                                                    header = "Tie!"
                                                    color = tieColor
                                                }
                                            }
                                        }
                                    }
                                    .padding(.bottom, 55)
                                
                                loadOrPickImage(seconds: 2, imageName: $player1Choice, offsetX: $offsetX2, offsetY: $offsetY2)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            withAnimation(.spring()) {
                                                offsetY2 = -10
                                                offsetX2 = 70
                                            }
                                        }
                                    }
                                    .padding(.bottom, 55)
                                
                                if anotherRound {
                                    withAnimation {
                                        VStack {
                                            Spacer()
                                            BottomButton(text: "Another round", action: defaultSettings)
                                        }
                                        .padding(.top, 500)
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(height: 432)
                
            }
            .frame(height: UIScreen.main.bounds.height)
            .navigationTitle("Round #1")
            
            VStack {
                Spacer()
                if selected && !next {
                    BottomButton(text: "I changed my mind", action: {
                        changed = true
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                    BottomButton(text: "Next", action: {
                        next = true
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.bottom, 60)
        }
        .padding(.vertical, 120)
        
        .onChange(of: currentPlayer, perform: { _ in
            if currentPlayer == "Player1" && next {
                header = "Pass the phone to your opponent"
            }
            else {
                changed = true
            }
        })
        
        .onChange(of: player2Choice, perform: { _ in
            switch player2Choice {
            case "paper": player2.choice = .paper
            case "rock": player2.choice = .rock
            case "scissors": player2.choice = .scissors
            default:
                break
            }
        })
        
        .onChange(of: player1Choice, perform: { _ in
            switch player1Choice {
            case "paper": player1.choice = .paper
            case "rock": player1.choice = .rock
            case "scissors": player1.choice = .scissors
            default:
                break
            }
        })
        
        .onChange(of: changed) { _ in
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
        
        .onChange(of: next) { _ in
            if next {
                withAnimation {
                    changed = false
                    selectedPaper = false
                    selectedScissors = false
                    selectedRock = false
                    selected = true
                    showScore = false
                }
                if currentPlayer == "Player2" {
                    player2.play(player2: player1)
                }
                else {
                    header = "Pass the phone to your opponent"
                }
            }
        }
        
        .onChange(of: selected) { _ in
            withAnimation {
                if selected {
                    header = playerPick
                }
            }
        }
    }
}


struct loadOrPickImage: View {
    var seconds: Int
    @Binding var imageName: String
    @State var Width: CGFloat = 348
    @Binding var offsetX: CGFloat
    @Binding var offsetY: CGFloat
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
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(seconds)) {
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

struct choiceButtonSingle: View {
    @Binding var isSelected: Bool
    @Binding var selected: Bool
    @Binding var choice: String
    @Binding var oponentChoice: String
    var image: String
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                isSelected = true
                selected = true
                choice = image
                oponentChoice = allCases[Int.random(in: 0..<allCases.count)].rawValue
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

struct choiceButtonMultiple: View {
    @Binding var isSelected: Bool
    @Binding var selected: Bool
    @Binding var choice: String
    var image: String
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                isSelected = true
                selected = true
                choice = image
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct BottomButton: View {
    var text: String
    var action: () -> ()
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                action()
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



