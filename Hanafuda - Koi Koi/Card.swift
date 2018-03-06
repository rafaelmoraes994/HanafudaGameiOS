//
//  Card.swift
//  Hanafuda - Koi Koi
//
//  Created by Rafael on 1/12/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit

class Card: Equatable {
    
    var image: UIImage
    var month: String
    
    
    init(image: UIImage, month: String) {
        self.image = image
        self.month = month
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.image == rhs.image
    }
    
}
