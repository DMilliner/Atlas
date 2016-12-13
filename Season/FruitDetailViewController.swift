//
//  FruitDetailViewController.swift
//  Season
//
//  Created by David Milliner on 11/15/16.
//  Copyright © 2016 David Milliner. All rights reserved.
//

import UIKit

class FruitDetailViewController: UIViewController {

    @IBOutlet weak var fruitNameLabel: UILabel!
    @IBOutlet weak var fruitImage: UIImageView!
    
    
    @IBOutlet weak var RedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var RedViewWidth: NSLayoutConstraint!

    
    @IBOutlet weak var PCa: NSLayoutConstraint!
    @IBOutlet weak var PCb: NSLayoutConstraint!
    @IBOutlet weak var PCc: NSLayoutConstraint!
    
    @IBOutlet weak var LCa: NSLayoutConstraint!
    @IBOutlet weak var LCb: NSLayoutConstraint!
    @IBOutlet weak var LCc: NSLayoutConstraint!
    
    func configureNameView() {
        // Update the user interface for the detail item.
        if let fruitName = self.fruitNameItem {
            print("-> Fruit Name " + fruitName.description)
            if let label = self.fruitNameLabel {
                label.text = fruitName.description
            }
        }else {
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "fruitsList") as UIViewController, animated: false)
        }
    }
    
    func configureImageView() {
        // Update the user interface for the detail item.
        if let fruitSection = self.fruitSectionItem {
            print("-> Fruit Section " + fruitSection.description)
            if let image = self.fruitImage {
                
                if(fruitSection == "Berries"){
                    image.backgroundColor = UIColor.init(red: 30/255.0, green: 90/255.0, blue: 225/255.0, alpha: 1.0)
                } else {
                    image.backgroundColor = UIColor.init(red: 245/255.0, green: 90/255.0, blue: 65/255.0, alpha: 1.0)
                }
                
            }
        }else {
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "fruitsList") as UIViewController, animated: false)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureNameView()
        self.configureImageView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var fruitNameItem: String? {
        didSet {
            // Update the view.
            self.configureNameView()
        }
    }
    
    var fruitSectionItem: String? {
        didSet {
            // Update the view.
            self.configureImageView()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            let orient = UIApplication.shared.statusBarOrientation
            
            switch orient {
            case .portrait:
                print("Portrait")
                self.applyPortraitConstraint()
                break
            // Do something
            default:
                print("LandScape")
                // Do something else
                self.applyLandScapeConstraint()
                break
            }
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            print("rotation completed")
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func applyPortraitConstraint(){
        self.view.addConstraint(self.RedViewHeight)
        self.view.addConstraint(self.PCa)
        self.view.addConstraint(self.PCb)
        self.view.addConstraint(self.PCc)
        
        self.view.removeConstraint(self.RedViewWidth)
        self.view.removeConstraint(self.LCa)
        self.view.removeConstraint(self.LCb)
        self.view.removeConstraint(self.LCc)
    }
    
    func applyLandScapeConstraint(){
        
        self.view.removeConstraint(self.RedViewHeight)
        self.view.removeConstraint(self.PCa)
        self.view.removeConstraint(self.PCb)
        self.view.removeConstraint(self.PCc)
        
        self.view.addConstraint(self.RedViewWidth)
        self.view.addConstraint(self.LCa)
        self.view.addConstraint(self.LCb)
        self.view.addConstraint(self.LCc)
    }
}

