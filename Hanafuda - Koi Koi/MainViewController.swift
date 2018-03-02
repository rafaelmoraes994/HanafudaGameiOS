//
//  ViewController.swift
//  Hanafuda - Koi Koi
//
//  Created by Rafael on 1/5/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var menuSubView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //GameController.shared.userSettings = Settings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openOptions(_ sender: UIButton) {
        self.view.bringSubview(toFront: menuSubView)
        menuSubView.isHidden = false
    }
}

