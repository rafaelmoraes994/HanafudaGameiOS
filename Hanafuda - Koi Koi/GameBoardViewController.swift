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

class GameBoardViewController: UIViewController, UICollectionViewDelegate, KDDragAndDropCollectionViewDataSource, GameCardMovement {
    
    @IBOutlet weak var playerSpecialCards: UICollectionView!
    @IBOutlet weak var playerHandCards: KDDragAndDropCollectionView!
    @IBOutlet weak var playerAnimalCards: UICollectionView!
    @IBOutlet weak var playerRibbonCards: UICollectionView!
    @IBOutlet weak var playerCommonCards: UICollectionView!
    @IBOutlet weak var tableCards: KDDragAndDropCollectionView!
    @IBOutlet weak var opponentSpecialCards: UICollectionView!
    @IBOutlet weak var opponentAnimalCards: UICollectionView!
    @IBOutlet weak var opponentRibbonCards: UICollectionView!
    @IBOutlet weak var opponentCommonCards: UICollectionView!
    @IBOutlet weak var opponentHandCards: UICollectionView!
    
    var dragAndDropManager : DragAndDropManager?
    var selectedCardIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameController.shared.initializeGame()
        
//        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
//        playerHandCards.addGestureRecognizer(longPressGesture)
        
        let draggableCollectionViews = [playerHandCards, tableCards]
        
        self.dragAndDropManager = DragAndDropManager(canvas: self.view, collectionViews: draggableCollectionViews as! [UIView])
        
        self.dragAndDropManager?.delegate = self
        
        initializeCollectionViews()
    }
    
    func initializeCollectionLayout(collectionView: UICollectionView) {
        let layout = collectionView.collectionViewLayout as! CardCustomCollectionViewLayout
        layout.updateAnimationStyle = .custom
        let configuration = layout.configuration
        configuration.stopAtItemBoundary = true
        configuration.offsetX = 0
        configuration.fadeFactor = 0
        configuration.scaleFactorX = 0
        configuration.scaleFactorY = 0
        configuration.rotateDirection = .z
        configuration.scrollDirection = .horizontal
        
        if collectionView != opponentHandCards && collectionView != playerHandCards {
            configuration.rotateFactor = 0
            configuration.spacing = -10
            configuration.cellSize = CGSize(width: 30, height: 48)
        } else {
            configuration.spacing = -20
            configuration.rotateFactor = 0.1
            configuration.cellSize = CGSize(width: 55, height: 88)
            let collectionViewInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
            collectionView.contentInset = collectionViewInsets

            if collectionView == opponentHandCards {
                collectionView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        }
    }
    
    func initializeCollectionViews(){
        
        initializeCollectionLayout(collectionView: playerHandCards)
        initializeCollectionLayout(collectionView: opponentHandCards)
        initializeCollectionLayout(collectionView: playerSpecialCards)
        initializeCollectionLayout(collectionView: playerAnimalCards)
        initializeCollectionLayout(collectionView: playerRibbonCards)
        initializeCollectionLayout(collectionView: playerCommonCards)
        initializeCollectionLayout(collectionView: opponentRibbonCards)
        initializeCollectionLayout(collectionView: opponentAnimalCards)
        initializeCollectionLayout(collectionView: opponentSpecialCards)
        initializeCollectionLayout(collectionView: opponentCommonCards)
        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GameController.shared.cardPositionArrays[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        
        let card = GameController.shared.cardPositionArrays[collectionView.tag][indexPath.row]

        cell.shouldAnimate = false
        if collectionView.tag == CardPosition.OpponentHand.rawValue {
            cell.cardImage.image = #imageLiteral(resourceName: "Card-Back")
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1.0
        } else {
            cell.cardImage.image = card.image
        }
        if collectionView.tag == CardPosition.PlayerHand.rawValue {
            if GameController.shared.checkMatchExistance(card) {
                CardController.shared.setCardLayerDesign(card: cell, shadowRadius: 3.0, borderWidth: 2.0)
            }
            if indexPath.row == selectedCardIndex {
                if let cv = collectionView as? KDDragAndDropCollectionView {
                    if cv.shouldAnimate == true {
                        cell.shouldAnimate = true
                    }
                }
            }
        } else if collectionView.tag == CardPosition.TableCard.rawValue{
            if GameController.shared.verifyMatch(card, selectedCardIndex){
                cell.overlay.isHidden = true
            } else {
                cell.overlay.isHidden = false
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cardLayout = collectionView.collectionViewLayout as? CardCustomCollectionViewLayout {
            cardLayout.selectedIndex = CGFloat(indexPath.row)
            selectedCardIndex = Int(cardLayout.selectedIndex)
            //reload PlayerHand
            collectionView.reloadData()
            //reload TableCards
            tableCards.reloadData()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> IndexPath? {
        guard let candidate = dataItem as? Card, collectionView.tag == CardPosition.PlayerHand.rawValue || collectionView.tag == CardPosition.TableCard.rawValue else { return nil }
        
        for (i,item) in GameController.shared.cardPositionArrays[collectionView.tag].enumerated() {
            if candidate != item { continue }
            return IndexPath(item: i, section: 0)
        }
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, dataItemForIndexPath indexPath: IndexPath) -> AnyObject {
        guard collectionView.tag == CardPosition.PlayerHand.rawValue || collectionView.tag == CardPosition.TableCard.rawValue else { return "" as AnyObject }
        return GameController.shared.cardPositionArrays[collectionView.tag][indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, moveDataItemFromIndexPath from: IndexPath, toIndexPath to: IndexPath) {
        guard collectionView.tag == CardPosition.PlayerHand.rawValue || collectionView.tag == CardPosition.TableCard.rawValue else { return }
        if collectionView == playerHandCards {
            let fromDataItem: Card = GameController.shared.cardPositionArrays[collectionView.tag][from.item]
            GameController.shared.cardPositionArrays[collectionView.tag].remove(at: from.item)
            GameController.shared.cardPositionArrays[collectionView.tag].insert(fromDataItem, at: to.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, insertDataItem dataItem: AnyObject, atIndexPath indexPath: IndexPath) {
        guard collectionView.tag == CardPosition.PlayerHand.rawValue || collectionView.tag == CardPosition.TableCard.rawValue else { return }
        if let card = dataItem as? Card {
            GameController.shared.cardPositionArrays[collectionView.tag].insert(card, at: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath: IndexPath) {
        guard collectionView.tag == CardPosition.PlayerHand.rawValue || collectionView.tag == CardPosition.TableCard.rawValue else { return }
        GameController.shared.cardPositionArrays[collectionView.tag].remove(at: indexPath.item)
    }
    
    func didStartLongPress() {
        print("Start")
    }
    
    func didStopLongPress() {
        print("Stop")
    }
    
    func didChangeSelectedIndex(_ indexPath: IndexPath) {
        if let cardLayout = playerHandCards.collectionViewLayout as? CardCustomCollectionViewLayout {
            cardLayout.selectedIndex = CGFloat(indexPath.row)
            selectedCardIndex = Int(cardLayout.selectedIndex)
        }
    }
}
