//
//  CardController.swift
//  Hanafuda - Koi Koi
//
//  Created by Rafael on 1/12/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit

class CardController {

    //Singleton
    fileprivate init() {}
    static let shared: CardController = CardController()
    
    let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
    
    func setPulseAnimations(card: UIView){
        pulseAnimation.duration = 0.8
        pulseAnimation.toValue = 1.1
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.infinity
        card.layer.add(pulseAnimation, forKey: nil)
    }
    
    func setCardLayerDesign(card: UIView, shadowRadius: CGFloat, borderWidth: CGFloat){
        card.layer.shadowColor = GameController.shared.pink.cgColor
        card.layer.shadowRadius = shadowRadius
        card.layer.shadowOpacity = 1.0
        card.layer.shadowOffset = CGSize(width: 0, height: 0)
        card.layer.borderColor = GameController.shared.pink.cgColor
        card.layer.borderWidth = borderWidth
    }
    
    func resetCardLayerDesign(card: UIView){
        card.layer.shadowRadius = 0
        card.layer.shadowOpacity = 0
        card.layer.borderWidth = 0
    }

}
