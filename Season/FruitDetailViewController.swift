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
    
    // FirstView Constraints
    @IBOutlet weak var L_FirstViewBottom: NSLayoutConstraint!
    @IBOutlet weak var L_FirstViewTop: NSLayoutConstraint!
    @IBOutlet weak var L_FirstViewLeading: NSLayoutConstraint!
    @IBOutlet weak var L_FirstViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var P_FirstViewBottom: NSLayoutConstraint!
    @IBOutlet weak var P_FirstViewTop: NSLayoutConstraint!
    @IBOutlet weak var P_FirstViewLeading: NSLayoutConstraint!
    @IBOutlet weak var P_FirstViewTrailing: NSLayoutConstraint!
    
    // SecondView Constraints
    @IBOutlet weak var L_SecondViewBottom: NSLayoutConstraint!
    @IBOutlet weak var L_SecondViewTop: NSLayoutConstraint!
    @IBOutlet weak var L_SecondViewLeading: NSLayoutConstraint!
    @IBOutlet weak var L_SecondViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var P_SecondViewBottom: NSLayoutConstraint!
    @IBOutlet weak var P_SecondViewTop: NSLayoutConstraint!
    @IBOutlet weak var P_SecondViewLeading: NSLayoutConstraint!
    @IBOutlet weak var P_SecondViewTrailing: NSLayoutConstraint!
    
    // ImageView Constraints
    @IBOutlet weak var L_ImageViewBottom: NSLayoutConstraint!
    @IBOutlet weak var L_ImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var L_ImageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var L_ImageViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var P_ImageViewBottom: NSLayoutConstraint!
    @IBOutlet weak var P_ImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var P_ImageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var P_ImageViewTrailing: NSLayoutConstraint!
    
    // Label Constraints
    @IBOutlet weak var L_LabelBottom: NSLayoutConstraint!
    @IBOutlet weak var L_LabelTop: NSLayoutConstraint!
    @IBOutlet weak var L_LabelLeading: NSLayoutConstraint!
    @IBOutlet weak var L_LabelTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var P_LabelBottom: NSLayoutConstraint!
    @IBOutlet weak var P_LabelTop: NSLayoutConstraint!
    @IBOutlet weak var P_LabelLeading: NSLayoutConstraint!
    @IBOutlet weak var P_LabelTrailing: NSLayoutConstraint!
    
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
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        
        if UIApplication.shared.statusBarOrientation.isLandscape {
            print("-- landscape")
            self.applyLandScapeConstraint()
        } else if UIApplication.shared.statusBarOrientation.isPortrait { // else portrait
            print("-- portrait")
            self.applyPortraitConstraint()
        }
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
    
//    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
//        // if landscape
//        if UIInterfaceOrientationIsLandscape(toInterfaceOrientation) {
//            print("-- landscape")
//            self.applyLandScapeConstraint()
//        } else { // else portrait
//            print("-- portrait")
//            self.applyPortraitConstraint()
//        }
//    }
    
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
        self.view.addConstraint(self.P_FirstViewTop)
        self.view.addConstraint(self.P_FirstViewBottom)
        self.view.addConstraint(self.P_FirstViewLeading)
        self.view.addConstraint(self.P_FirstViewTrailing)
        self.view.addConstraint(self.P_SecondViewTop)
        self.view.addConstraint(self.P_SecondViewBottom)
        self.view.addConstraint(self.P_SecondViewTrailing)
        self.view.addConstraint(self.P_SecondViewLeading)
        self.view.addConstraint(self.P_ImageViewTop)
        self.view.addConstraint(self.P_ImageViewBottom)
        self.view.addConstraint(self.P_ImageViewTrailing)
        self.view.addConstraint(self.P_ImageViewLeading)
        self.view.addConstraint(self.P_LabelTop)
        self.view.addConstraint(self.P_LabelBottom)
        self.view.addConstraint(self.P_LabelTrailing)
        self.view.addConstraint(self.P_LabelLeading)
        
        self.view.removeConstraint(self.L_FirstViewTop)
        self.view.removeConstraint(self.L_FirstViewBottom)
        self.view.removeConstraint(self.L_FirstViewLeading)
        self.view.removeConstraint(self.L_FirstViewTrailing)
        self.view.removeConstraint(self.L_SecondViewTop)
        self.view.removeConstraint(self.L_SecondViewBottom)
        self.view.removeConstraint(self.L_SecondViewTrailing)
        self.view.removeConstraint(self.L_SecondViewLeading)
        self.view.removeConstraint(self.L_ImageViewTop)
        self.view.removeConstraint(self.L_ImageViewBottom)
        self.view.removeConstraint(self.L_ImageViewTrailing)
        self.view.removeConstraint(self.L_ImageViewLeading)
        self.view.removeConstraint(self.L_LabelTop)
        self.view.removeConstraint(self.L_LabelBottom)
        self.view.removeConstraint(self.L_LabelTrailing)
        self.view.removeConstraint(self.L_LabelLeading)
    }
    
    func applyLandScapeConstraint(){
        self.view.removeConstraint(self.P_FirstViewTop)
        self.view.removeConstraint(self.P_FirstViewBottom)
        self.view.removeConstraint(self.P_FirstViewLeading)
        self.view.removeConstraint(self.P_FirstViewTrailing)
        self.view.removeConstraint(self.P_SecondViewTop)
        self.view.removeConstraint(self.P_SecondViewBottom)
        self.view.removeConstraint(self.P_SecondViewTrailing)
        self.view.removeConstraint(self.P_SecondViewLeading)
        self.view.removeConstraint(self.P_ImageViewTop)
        self.view.removeConstraint(self.P_ImageViewBottom)
        self.view.removeConstraint(self.P_ImageViewTrailing)
        self.view.removeConstraint(self.P_ImageViewLeading)
        self.view.removeConstraint(self.P_LabelTop)
        self.view.removeConstraint(self.P_LabelBottom)
        self.view.removeConstraint(self.P_LabelTrailing)
        self.view.removeConstraint(self.P_LabelLeading)
        
        self.view.addConstraint(self.L_FirstViewTop)
        self.view.addConstraint(self.L_FirstViewBottom)
        self.view.addConstraint(self.L_FirstViewLeading)
        self.view.addConstraint(self.L_FirstViewTrailing)
        self.view.addConstraint(self.L_SecondViewTop)
        self.view.addConstraint(self.L_SecondViewBottom)
        self.view.addConstraint(self.L_SecondViewTrailing)
        self.view.addConstraint(self.L_SecondViewLeading)
        self.view.addConstraint(self.L_ImageViewTop)
        self.view.addConstraint(self.L_ImageViewBottom)
        self.view.addConstraint(self.L_ImageViewTrailing)
        self.view.addConstraint(self.L_ImageViewLeading)
        self.view.addConstraint(self.L_LabelTop)
        self.view.addConstraint(self.L_LabelBottom)
        self.view.addConstraint(self.L_LabelTrailing)
        self.view.addConstraint(self.L_LabelLeading)
    }

}

