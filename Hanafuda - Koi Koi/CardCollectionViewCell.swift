//
//  PlayerHandCollectionViewCell.swift
//  Hanafuda - Koi Koi
//
//  Created by Rafael on 1/18/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cardImage: UIImageView!
    
    var shouldAnimate = false
    
    override func prepareForReuse() {
        CardController.shared.resetCardLayerDesign(card: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.removeAllAnimations()
        if shouldAnimate {
            let delayTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                CardController.shared.setPulseAnimations(card: self)
            }
        }
    }
}
