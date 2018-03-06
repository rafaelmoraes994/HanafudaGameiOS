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
                self.swapAt(i, j)
            }
        }
    }
}

enum CardPosition: Int {
    case PlayerHand
    case OpponentHand
    case PlayerSpecial
    case PlayerAnimal
    case PlayerRibbon
    case PlayerCommon
    case OpponentSpecial
    case OpponentAnimal
    case OpponentRibbon
    case OpponentCommon
    case TableCard
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
    
    var cardPositionArrays: [[Card]] = []
       
    func initializeDeck(){
        for i in 0...monthCardNames.count-1 {
            for j in 0...3{
                deck.append(Card(image: UIImage(named: monthCardNames[i] + String(j))!, month: monthCardNames[i]))
            }
        }
        deck.shuffle()
    }
    
    func initializeGame () {
        initializeDeck()
        initializeCardPositionArrays()
        initializeTableCards()
        initializePlayersCards()
    }
    
    func initializeCardPositionArrays(){
        for _ in 0...CardPosition.TableCard.rawValue {
            cardPositionArrays.append([])
        }
    }
    
    func initializeTableCards(){
        for _ in 0..<8 {
            cardPositionArrays[CardPosition.TableCard.rawValue].append(deck.remove(at: 0))
        }
    }
    
    func initializePlayersCards(){
        for _ in 0..<8 {
            cardPositionArrays[CardPosition.PlayerHand.rawValue].append(deck.remove(at: 0))
            cardPositionArrays[CardPosition.OpponentHand.rawValue].append(deck.remove(at: 0))
        }
    }
    
    func initializePlayers (dealer: String, opponent: String){
        currentPlayer = Player(name: dealer, handCards: [], comboCards: [])
        nextPlayer = Player(name: opponent, handCards: [], comboCards: [])
    }
    
    func checkMatchExistance(card: Card) -> Bool{
        var tableCards = cardPositionArrays[CardPosition.TableCard.rawValue]
        for i in 0..<tableCards.count {
            if card.month == tableCards[i].month {
                return true
            }
        }
        return false
    }
    
}
