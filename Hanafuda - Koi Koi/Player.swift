//
//  Player.swift
//  Hanafuda - Koi Koi
//
//  Created by Rafael on 1/12/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit

class Player {

    var name: String
    var handCards = [Card]()
    var comboCards = [Card]()
    
    init(name: String, handCards: [Card], comboCards: [Card]) {
        self.name = name
        self.handCards = handCards
        self.comboCards = comboCards
    }
    
    
}
