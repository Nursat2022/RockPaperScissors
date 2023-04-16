//
//  Model.swift
//  RockPaperScissorsApp
//
//  Created by Nursat Sakyshev on 16.04.2023.
//

import Foundation

import UIKit

enum elements: String, CaseIterable {
    case rock = "rock"
    case paper = "paper"
    case scissors = "scissors"
}

protocol canPlayInRSPGame {
    var choice: elements { get set }
    
    func play(player2: Player)
}

enum statusGame {
    case win
    case lose
    case tie
}

class Player: canPlayInRSPGame {
    
    var choice: elements
    var score = 0 {
        didSet {
            if score < 0 {
                score = 0
            }
        }
    }
    var name: String
    var status: statusGame {
        didSet {
            switch status {
            case .win:
                score += 1
            case .lose:
                break
            case .tie:
                break
            }
        }
    }
    
    init(name: String, choice: elements) {
        self.name = name
        self.choice = choice
        self.status = .tie
    }
    
    func play(player2: Player) {
        let first = self.choice
        let second = player2.choice
        
//        print("\(self.name) chose \(first.rawValue), \(player2.name) chose \(second.rawValue)")
        
        if first.rawValue == second.rawValue {
            print("There's no a winner")
        }
        else { // win
            if (self.choice == .rock && player2.choice == .scissors
                || self.choice == .scissors && player2.choice == .paper
                || self.choice == .paper && player2.choice == .rock) {
                
                status = .win
                player2.status = .lose
                print("\(first.rawValue) beats \(second.rawValue)")
                print("\(self.name) wins")
            }
            else { // lose
                print("\(second.rawValue) beats \(first.rawValue)")
                print("\(player2.name) wins")
                status = .lose
                player2.status = .win
            }
        }
    }
}

let allCases = elements.allCases

var p1 = Player(name: "Nursat", choice: allCases[Int.random(in: 0..<allCases.count)])
var p2 = Player(name: "Madi", choice: allCases[Int.random(in: 0..<allCases.count)])


