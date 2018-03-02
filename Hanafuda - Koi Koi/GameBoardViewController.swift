//
//  GameBoardViewController.swift
//  Hanafuda - Koi Koi
//
//  Created by Rafael on 1/12/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit
import SpriteKit
import CPCollectionViewKit

class GameBoardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet weak var playerSpecialCards: UICollectionView!
    @IBOutlet weak var playerHandCards: UICollectionView!
    @IBOutlet weak var playerAnimalCards: UICollectionView!
    @IBOutlet weak var playerRibbonCards: UICollectionView!
    @IBOutlet weak var playerCommonCards: UICollectionView!
    @IBOutlet weak var tableCards: UICollectionView!
    @IBOutlet weak var opponentSpecialCards: UICollectionView!
    @IBOutlet weak var opponentAnimalCards: UICollectionView!
    @IBOutlet weak var opponentRibbonCards: UICollectionView!
    @IBOutlet weak var opponentCommonCards: UICollectionView!
    @IBOutlet weak var opponentHandCards: UICollectionView!
    
    var configuration: CardLayoutConfiguration!
    var layout: CollectionViewCardLayout!
//    var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //GameController.shared.initializeTableCards()
        
//        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
//        playerHandCards.addGestureRecognizer(longPressGesture)
        initializeCollectionViews()
    }
    
    func initializeCollectionLayout(collectionView: UICollectionView){
        layout = collectionView.collectionViewLayout as! CardCustomCollectionViewLayout
        layout.updateAnimationStyle = .custom
        configuration = layout.configuration
        configuration.stopAtItemBoundary = true
        configuration.spacing = -20
        configuration.offsetX = 0
        configuration.fadeFactor = 0
        configuration.scaleFactorX = 0
        configuration.scaleFactorY = 0
        configuration.rotateFactor = 0.1
        configuration.rotateDirection = .z
        configuration.scrollDirection = .horizontal
        configuration.cellSize = CGSize(width: 60, height: 96)
        
        let collectionViewInsets = UIEdgeInsets(top: 0.0, left: 30.0, bottom: 0.0, right: 0.0)
        collectionView.contentInset = collectionViewInsets
        
        if collectionView == opponentHandCards {
            collectionView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }

    }
    
    func initializeCollectionViews(){
        
        initializeCollectionLayout(collectionView: playerHandCards)
        initializeCollectionLayout(collectionView: opponentHandCards)
        
        self.playerHandCards.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        self.playerSpecialCards.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        self.playerAnimalCards.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        self.playerRibbonCards.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        self.playerCommonCards.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        self.tableCards.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        self.opponentSpecialCards.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        self.opponentAnimalCards.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        self.opponentRibbonCards.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        self.opponentCommonCards.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        self.opponentHandCards.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
    }

//    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
//        switch(gesture.state) {
//
//        case .began:
//            guard let selectedIndexPath = playerHandCards.indexPathForItem(at: gesture.location(in: playerHandCards)) else {
//                break
//            }
//            playerHandCards.beginInteractiveMovementForItem(at: selectedIndexPath)
//        case .changed:
//            playerHandCards.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
//        case .ended:
//            playerHandCards.endInteractiveMovement()
//        default:
//            playerHandCards.cancelInteractiveMovement()
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfCards = 0
        if collectionView == self.playerHandCards || collectionView == self.opponentHandCards{
            numberOfCards = 8
        } else if collectionView == self.tableCards {
            numberOfCards = 12
        } else {
            numberOfCards = 5
        }
        return numberOfCards
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        
        if collectionView == opponentHandCards {
            cell.cardImage.image = #imageLiteral(resourceName: "Card-Back")
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1.0
        } else {
           cell.cardImage.image = GameController.shared.deck[indexPath.row].image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cardLayout = layout as? CardCustomCollectionViewLayout {
            cardLayout.selectedIndex = CGFloat(indexPath.row)
            collectionView.reloadData()
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        print("Starting Index: \(sourceIndexPath.item)")
//        print("Ending Index: \(destinationIndexPath.item)")
//    }
}
