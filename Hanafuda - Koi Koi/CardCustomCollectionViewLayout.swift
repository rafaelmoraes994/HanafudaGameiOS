//
//  CardCustomCollectionViewLayout.swift
//  Hanafuda - Koi Koi
//
//  Created by Rafael on 1/18/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit
import CPCollectionViewKit

class CardCustomCollectionViewLayout: CollectionViewCardLayout {
    
    var selectedIndex : CGFloat = 7
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let collectionView = collectionView,
            let attributes = super.layoutAttributesForItem(at: indexPath) else { return  super.layoutAttributesForItem(at: indexPath) }
        
        let item = CGFloat(indexPath.item)
        let width = collectionView.bounds.size.width
        let height = collectionView.bounds.size.height
        let cellSize = configuration.cellSize
        let cellWidth = cellSize.width
        let cellHeight = cellSize.height
        var centerX: CGFloat = 0.0
        var centerY: CGFloat = 0.0
        let topItemIndex = selectedIndex
        let itemOffset = item-topItemIndex
        
        attributes.size = cellSize
        if configuration.scrollDirection == .horizontal {
            centerX = (item+0.5)*cellWidth+item*configuration.spacing
            centerY = height/2.0
        } else {
            centerX = width/2.0
            centerY = (item+0.5)*cellHeight+item*configuration.spacing
        }
        
        attributes.center = CGPoint(x: centerX+configuration.offsetX, y: centerY+configuration.offsetY)
        
        attributes.alpha = 1-configuration.fadeFactor*fabs(itemOffset)
        
        let scaleFactorX = fabs(1-configuration.scaleFactorX*fabs(itemOffset))
        let scaleFactorY = fabs(1-configuration.scaleFactorY*fabs(itemOffset))
        
        var rotateFactor: CGFloat = 0.0
        
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        
        let centerCard = CGFloat(numberOfItems/2)
        let secondCenterCard = CGFloat(numberOfItems/2-1)
        var cardHeightPosition = 0.0
        
        if configuration.rotateFactor != 0 {
            //case even hand
            if numberOfItems % 2 == 0 {
                if item == secondCenterCard {
                    rotateFactor = -0.05
                } else if item == centerCard {
                    rotateFactor = 0.05
                } else {
                    if item > centerCard {
                        rotateFactor = configuration.rotateFactor*(item - centerCard)
                        cardHeightPosition = pow(2,Double(item - centerCard))
                        if item != centerCard+1 {
                            cardHeightPosition = cardHeightPosition + pow(2,Double(item - centerCard))
                        }
                    } else if item < secondCenterCard{
                        rotateFactor = -configuration.rotateFactor*(secondCenterCard - item)
                        cardHeightPosition = pow(2,Double(secondCenterCard - item))
                        if item != secondCenterCard-1 {
                            cardHeightPosition = cardHeightPosition + pow(2,Double(secondCenterCard - item))
                        }
                    }
                }
                //case odd hand
            } else if item != centerCard {
                cardHeightPosition = pow(2,abs(Double(item - centerCard)))
                rotateFactor = configuration.rotateFactor*(item - centerCard)
                if item != centerCard+1 && item != centerCard-1 {
                    cardHeightPosition = cardHeightPosition + pow(2,abs(Double(item - centerCard)))
                }
            }
            
            //var cardHeightPostion = 2*abs(Double((item - CGFloat(centerCard))))
            
            if numberOfItems % 2 == 0 {
                if item == 0 || item == 7 {
                    cardHeightPosition = cardHeightPosition + 2
                }
            } else if item == 0 || item == 6 {
                cardHeightPosition = cardHeightPosition + 2
            }
        }
        
        var transform3D = CATransform3DIdentity
        transform3D.m34 = -1/550
        transform3D = CATransform3DScale(transform3D, scaleFactorX, scaleFactorY, 1)
        
        transform3D = CATransform3DTranslate(transform3D, 0, CGFloat(cardHeightPosition), 0)
        
        switch configuration.rotateDirection {
        case .x:
            transform3D = CATransform3DRotate(transform3D, rotateFactor, 1, 0, 0)
        case .y:
            transform3D = CATransform3DRotate(transform3D, rotateFactor, 0, 1, 0)
        default:
            transform3D = CATransform3DRotate(transform3D, rotateFactor, 0, 0, 1)
        }
        
        attributes.transform3D = transform3D
        attributes.zIndex = (itemOffset<0.5 && itemOffset > -0.5) ? 1000 : Int(item)
        
        return attributes
    }
}
