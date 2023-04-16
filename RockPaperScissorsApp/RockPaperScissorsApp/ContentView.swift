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
                
                numberOfPlayers(isPlaying: $isPlayingSingle, players: "Single player")
                numberOfPlayers(isPlaying: $isPlayingMultiple, players: "Multi player")
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
        header = "Take your pick"
        loadOrPick = "loading"
        result = "Tie!"
        changed = false
        selectedPaper = false
        selectedScissors = false
        selectedRock = false
        selected = false
        next = false
        showScore = true
        buttonWidth = 348
        offsetX1 = 0
        offsetY1 = 0
        offsetX2 = UIScreen.main.bounds.width
        offsetY2 = 0
        color = [.black]
        anotherRound = false
        playerChoice = ""
        oponentChoice = ""
        player.status = .tie
        oponent.status = .tie
    }
    
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
                        choiceButton(isSelected: $selectedPaper, selected: $selected, choice: $playerChoice, oponentChoice: $oponentChoice, image: "paper")
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    if !selected || selectedScissors {
                        choiceButton(isSelected: $selectedScissors, selected: $selected, choice: $playerChoice, oponentChoice: $oponentChoice, image: "scissors")
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    if !selected || selectedRock {
                        choiceButton(isSelected: $selectedRock, selected: $selected, choice: $playerChoice, oponentChoice: $oponentChoice, image: "rock")
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
                                                header = result
                                                showScore = true
                                                anotherRound = true
                                                color = loseColor
                                                switch player.status {
                                                case .win:
                                                    header = "Win!"
                                                    color = winColor
                                                case .lose:
                                                    header = "Lose"
                                                    color = loseColor
                                                case.tie:
                                                    header = "Tie!"
                                                    color = tieColor
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom, 55)
                            
                            loadOrPickImage(imageName: $playerChoice, offsetX: $offsetX2, offsetY: $offsetY2)
                                .onAppear {
                                    if loadOrPick == "loading" {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            withAnimation {
                                                header = oponentPick
                                                loadOrPick = player.choice.rawValue
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
//                                        changeOrNext(changeView: $changed, text: "Another round")
                                        anotherButton(text: "Another round", action: defaultSettings)
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
        
        .onChange(of: oponentChoice, perform: { newValue in
            switch oponentChoice {
            case "paper": oponent.choice = .paper
            case "rock": oponent.choice = .rock
            case "scissors": oponent.choice = .scissors
            default:
                break
            }
        })
        
        .onChange(of: playerChoice, perform: { newValue in
            switch playerChoice {
            case "paper": player.choice = .paper
            case "rock": player.choice = .rock
            case "scissors": player.choice = .scissors
            default:
                break
            }
        })
        
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


struct MultiplePlayer: View {
    func defaultSettings() {
        header = "Take your pick"
        loadOrPick = "loading"
        result = "Tie!"
        changed = false
        selectedPaper = false
        selectedScissors = false
        selectedRock = false
        selected = false
        next = false
        showScore = true
        buttonWidth = 348
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
    }
    
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
                        Text("\(player1.name) · Score \(player1.score):\(player2.score)")
                            .foregroundColor(Color(red: 103/255, green: 80/255, blue: 164/255))
                    }
                }
                
                VStack(spacing: 24) {
                    if !selected || selectedPaper {
                        choiceButton(isSelected: $selectedPaper, selected: $selected, choice: $player1Choice, oponentChoice: $player2Choice, image: "paper")
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    if !selected || selectedScissors {
                        choiceButton(isSelected: $selectedScissors, selected: $selected, choice: $player1Choice, oponentChoice: $player2Choice, image: "scissors")
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    if !selected || selectedRock {
                        choiceButton(isSelected: $selectedRock, selected: $selected, choice: $player1Choice, oponentChoice: $player2Choice, image: "rock")
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    if next {
                        if currentPlayer == "Player1" {
                            VStack {
                                Spacer()
                                changeOrNext(changeView: $changed, text: "ready")
                            }
                        }
                        else {
                            ZStack {
                                loadOrPickImage(imageName: $loadOrPick, offsetX: $offsetX1, offsetY: $offsetY1)
                                    .onAppear {
                                        if loadOrPick == "loading" {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                withAnimation {
                                                    header = oponentPick
                                                    loadOrPick = player2.choice.rawValue
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
                                                    switch player1.status {
                                                    case .win:
                                                        header = "Win!"
                                                        color = winColor
                                                    case .lose:
                                                        header = "Lose"
                                                        color = loseColor
                                                    case.tie:
                                                        header = "Tie!"
                                                        color = tieColor
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(.bottom, 55)
                                
                                loadOrPickImage(imageName: $player1Choice, offsetX: $offsetX2, offsetY: $offsetY2)
                                    .onAppear {
                                        if loadOrPick == "loading" {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                withAnimation {
                                                    header = oponentPick
                                                    loadOrPick = player1.choice.rawValue
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
                                            //                                        changeOrNext(changeView: $changed, text: "Another round")
                                            anotherButton(text: "Another round", action: defaultSettings)
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
            .onChange(of: currentPlayer, perform: { newValue in
                if currentPlayer == "Player1" {
                    header = "Pass the phone to your ozxpponent"
                }
            })
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
        
        .onChange(of: player2Choice, perform: { newValue in
            switch player2Choice {
            case "paper": player2.choice = .paper
            case "rock": player2.choice = .rock
            case "scissors": player2.choice = .scissors
            default:
                break
            }
        })
        
        .onChange(of: player1Choice, perform: { newValue in
            switch player1Choice {
            case "paper": player1.choice = .paper
            case "rock": player1.choice = .rock
            case "scissors": player1.choice = .scissors
            default:
                break
            }
        })
        
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

struct anotherButton: View {
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


struct BottomButton: View {
    @Binding var changeView: Bool
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
