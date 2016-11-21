//
//  WelcomeViewController.swift
//  Season
//
//  Created by David Milliner on 11/17/16.
//  Copyright © 2016 David Milliner. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    var window: UIWindow?

    @IBOutlet var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        welcomeLabel.text = "Welcome to Season"

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
