//
//  GameController.swift
//  Hanafuda - Koi Koi
//
//  Created by Rafael on 1/6/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit
import Foundation

extension Array {
    public mutating func shuffle() {
        for i in stride(from: count - 1, through: 1, by: -1) {
            let j = Int(arc4random_uniform(UInt32(i+1)))
            if i != j {
                swap(&self[i], &self[j])
            }
        }
    }
}


class GameController {

    //Singleton
    fileprivate init() {}
    static let shared: GameController = GameController()
    
    let pink = UIColor(red: 244/255, green: 37/255, blue: 223/255, alpha: 1.0)
    
    let monthCardNames = ["matsu", "ume", "sakura", "huji", "syobu", "botan", "hagi", "susuki", "kiku", "momiji", "yanagi", "kiri"]
    
    var userSettings = Settings()
    
    var currentPlayer: Player?
    
    var nextPlayer: Player?
    
    var deck: [Card] = []
    
    var tableCards: [Card] = []
    
    
    func initializeDeck(){
        for i in 0...monthCardNames.count-1 {
            for j in 0...3{
                deck.append(Card(image: UIImage(named: monthCardNames[i] + String(j))!, month: monthCardNames[i]))
            }
        }
        deck.shuffle()
    }
    
    func initializeTableCards (){
        
    }
    
    func testDeck(){
        for i in 0...deck.count-1 {
            print(deck[i].month)
        }
    }
    
    func initializePlayers (dealer: String, opponent: String){
        currentPlayer = Player(name: dealer, handCards: [], comboCards: [])
        nextPlayer = Player(name: opponent, handCards: [], comboCards: [])
    }
    
}
