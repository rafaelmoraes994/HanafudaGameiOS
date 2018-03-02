//
//  MainMenuViewController.swift
//  Hanafuda - Koi Koi
//
//  Created by Rafael on 1/5/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit
import DropDown
import PureLayout

class MainMenuView: UIView {
    
    @IBOutlet var mainMenuView: UIView!
    
    @IBOutlet weak var hintsSwitch: UISwitch!
    
    @IBOutlet weak var doublePointsSwitch: UISwitch!
    
    @IBOutlet weak var hinamiSwitch: UISwitch!
    
    @IBOutlet weak var tsukimiSwitch: UISwitch!
    
    @IBOutlet weak var rounds: UIView!
    
    @IBOutlet weak var roundsButton: UIButton!
    
    @IBAction func showRoundsOptions(_ sender: Any) {
        roundsDropDown.show()
    }
    
    @IBAction func saveSettings(_ sender: Any) {
        GameController.shared.userSettings.update(hints: hintsSwitch.isOn, doublePoints: doublePointsSwitch.isOn, hinami: hinamiSwitch.isOn, tsukimi: tsukimiSwitch.isOn, rounds: Int(roundsButton.title(for: .normal)!)!)
        self.isHidden = true
    }
    
    let roundsDropDown = DropDown()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("MainMenu", owner: self, options: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("MainMenu", owner: self, options: nil)
        addSubview(mainMenuView)
        mainMenuView.autoPinEdge(.top, to: .top, of: self)
        mainMenuView.autoPinEdge(.bottom, to: .bottom, of: self)
        mainMenuView.autoPinEdge(.left, to: .left, of: self)
        mainMenuView.autoPinEdge(.right, to: .right, of: self)
    }
    
    override func awakeFromNib() {
        adjustButtonsInterface()
        roundsDropDown.anchorView = rounds
        roundsDropDown.dataSource = ["3", "6", "12"]
        roundsDropDown.backgroundColor = UIColor.white
        roundsDropDown.selectionBackgroundColor = GameController.shared.pink
        roundsDropDown.layer.cornerRadius = roundsDropDown.frame.height/2
        roundsDropDown.dismissMode = .onTap
        roundsDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.roundsButton.setTitle(self.roundsDropDown.selectedItem, for: .normal)
        }
    }
    
    func adjustButtonsInterface(){
        roundsButton.setTitle("\(GameController.shared.userSettings.rounds)", for: .normal)
        roundsButton.setTitleColor(UIColor.black, for: .normal)
        roundsButton.layer.borderColor = GameController.shared.pink.cgColor
        roundsButton.layer.borderWidth = 1.0
        roundsButton.layer.cornerRadius = roundsButton.frame.height/2
        
        hintsSwitch.setOn(GameController.shared.userSettings.hints, animated: false)
        
        hinamiSwitch.setOn(GameController.shared.userSettings.hinami, animated: false)
        
        tsukimiSwitch.setOn(GameController.shared.userSettings.tsukimi, animated: false)
        
        doublePointsSwitch.setOn(GameController.shared.userSettings.doublePoints, animated: false)
        
    }
    
    
}
