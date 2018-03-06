//
//  DealerContestViewController.swift
//  Hanafuda - Koi Koi
//
//  Created by Rafael on 1/9/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit

class DealerContestViewController: UIViewController {
    
    @IBOutlet weak var titleMessage: UILabel!
    
    @IBOutlet weak var leftCard: UIButton!
    
    @IBOutlet weak var rightCard: UIButton!
    
    @IBOutlet weak var resultMessage: UILabel!
    
    @IBAction func leftCardChosen(_ sender: Any) {
        dealerContest(chosenCard: "left")
    }
    
    @IBAction func rightCardChosen(_ sender: Any) {
        dealerContest(chosenCard: "right")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleMessage.adjustsFontSizeToFitWidth = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var countdownTimer = 4
    var startGameTimer = Timer()
    
    
    func dealerContest(chosenCard: String) {
        
        let leftCardMonthIndex = Int(arc4random_uniform(12))
        let leftCardMonth = GameController.shared.monthCardNames[leftCardMonthIndex]
        let leftCardImage = UIImage(named: leftCardMonth + "0")
        
        var rightCardMonthIndex = Int(arc4random_uniform(12))
        var rightCardMonth = GameController.shared.monthCardNames[rightCardMonthIndex]
        while leftCardMonth == rightCardMonth {
            rightCardMonthIndex = Int(arc4random_uniform(12))
            rightCardMonth = GameController.shared.monthCardNames[rightCardMonthIndex]
        }
        let rightCardImage = UIImage(named: rightCardMonth + "0")
        
        let chosenCardButton : UIButton
        let nonChosenCardButton: UIButton
        let chosenCardImage: UIImage?
        let nonChosenCardImage: UIImage?
        
        if chosenCard == "left" {
            chosenCardButton = leftCard
            nonChosenCardButton = rightCard
            chosenCardImage = leftCardImage
            nonChosenCardImage = rightCardImage
        } else {
            chosenCardButton = rightCard
            nonChosenCardButton = leftCard
            chosenCardImage = rightCardImage
            nonChosenCardImage = leftCardImage
        }

        chosenCardButton.setImage(chosenCardImage, for: .normal)
        UIView.transition(with: chosenCardButton, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: {
            finished in
            nonChosenCardButton.setImage(nonChosenCardImage, for: .normal)
            UIView.transition(with: nonChosenCardButton, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: {
                finished in
                if (chosenCard == "left" && leftCardMonthIndex > rightCardMonthIndex) || (chosenCard == "right" && rightCardMonthIndex > leftCardMonthIndex) {
                        self.resultMessage.text = "Congrats! You start as the Dealer!"
                        CardController.shared.setCardLayerDesign(card: chosenCardButton)
                        CardController.shared.setPulseAnimations(card: chosenCardButton)
                        GameController.shared.initializePlayers(dealer: "user", opponent: "computer")
                    } else{
                        self.resultMessage.text = "Opponent player start as the Dealer"
                        CardController.shared.setCardLayerDesign(card: nonChosenCardButton)
                        CardController.shared.setPulseAnimations(card: nonChosenCardButton)
                        GameController.shared.initializePlayers(dealer: "computer", opponent: "user")
                    }
                }
            )})
        leftCard.isUserInteractionEnabled = false
        rightCard.isUserInteractionEnabled = false
        startGameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(DealerContestViewController.gameStart), userInfo: nil, repeats: true)
    }
    
    func gameStart() {
        countdownTimer -= 1
        titleMessage.text = "Game will start in:  " + String(countdownTimer)
        
        if countdownTimer == 0 {
            startGameTimer.invalidate()
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gameBoard") as! GameBoardViewController
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    
}
