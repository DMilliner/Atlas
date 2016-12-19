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
    @IBOutlet weak var L_FirstViewTrailing_alt: NSLayoutConstraint!
    
    @IBOutlet weak var P_FirstViewBottom_alt: NSLayoutConstraint!
    @IBOutlet weak var P_FirstViewTop: NSLayoutConstraint!
    @IBOutlet weak var P_FirstViewLeading: NSLayoutConstraint!
    @IBOutlet weak var P_FirstViewTrailing: NSLayoutConstraint!
    
    // SecondView Constraints
    @IBOutlet weak var L_SecondViewBottom: NSLayoutConstraint!
    @IBOutlet weak var L_SecondViewTop: NSLayoutConstraint!
    @IBOutlet weak var L_SecondViewLeading: NSLayoutConstraint!
    @IBOutlet weak var L_SecondViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var P_SecondViewBottom: NSLayoutConstraint!
    @IBOutlet weak var P_SecondViewTop_alt: NSLayoutConstraint!
    @IBOutlet weak var P_SecondViewLeading: NSLayoutConstraint!
    @IBOutlet weak var P_SecondViewTrailing: NSLayoutConstraint!
    
    // ImageView Constraints
    @IBOutlet weak var L_ImageViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var L_ImageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var L_ImageViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var P_ImageViewBottom: NSLayoutConstraint!
    @IBOutlet weak var P_ImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var P_ImageViewCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var ImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var ImageViewAspectRatio: NSLayoutConstraint!
    
    // Label Constraints
    @IBOutlet weak var L_LabelCenterY: NSLayoutConstraint!
    @IBOutlet weak var L_LabelLeading: NSLayoutConstraint!
    @IBOutlet weak var L_LabelTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var P_LabelCenterY: NSLayoutConstraint!
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(FruitDetailViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func rotated() {
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
        {
            print(" --- landscape")
            applyFruitLandScapeConstraint()
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation))
        {
            print(" --- Portrait")
            applyFruitPortraitConstraint()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
//            print("--  -F- wR --  landscape")
//            self.applyFruitLandScapeConstraint()
//        } else { // else portrait
//            print("-- portrait")
//            self.applyFruitPortraitConstraint()
//        }
//    }
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        let orientation: UIInterfaceOrientationMask = [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.landscape]
//        return orientation
//    }
//    
//    override var shouldAutorotate: Bool {
//        return false
//    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            switch UIApplication.shared.statusBarOrientation {
            case .portrait:
                print("Portrait")
                self.applyFruitPortraitConstraint()
                break
            default:
                print("LandScape")
                self.applyFruitLandScapeConstraint()
                break
            }
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            print("rotation completed")
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func applyFruitPortraitConstraint(){
        self.view.addConstraint(self.P_FirstViewTop)
        self.view.addConstraint(self.P_FirstViewBottom_alt)
        self.view.addConstraint(self.P_FirstViewLeading)
        self.view.addConstraint(self.P_FirstViewTrailing)
        self.view.addConstraint(self.P_SecondViewTop_alt)
        self.view.addConstraint(self.P_SecondViewBottom)
        self.view.addConstraint(self.P_SecondViewTrailing)
        self.view.addConstraint(self.P_SecondViewLeading)
        self.view.addConstraint(self.P_ImageViewTop)
        self.view.addConstraint(self.P_ImageViewBottom)
        self.view.addConstraint(self.P_ImageViewCenterX)
        self.view.addConstraint(self.P_LabelCenterY)
        self.view.addConstraint(self.P_LabelTrailing)
        self.view.addConstraint(self.P_LabelLeading)
        
        self.view.removeConstraint(self.L_FirstViewTop)
        self.view.removeConstraint(self.L_FirstViewBottom)
        self.view.removeConstraint(self.L_FirstViewLeading)
        self.view.removeConstraint(self.L_FirstViewTrailing_alt)
        self.view.removeConstraint(self.L_SecondViewTop)
        self.view.removeConstraint(self.L_SecondViewBottom)
        self.view.removeConstraint(self.L_SecondViewTrailing)
        self.view.removeConstraint(self.L_SecondViewLeading)
        self.view.removeConstraint(self.L_ImageViewCenterY)
        self.view.removeConstraint(self.L_ImageViewTrailing)
        self.view.removeConstraint(self.L_ImageViewLeading)
        self.view.removeConstraint(self.L_LabelCenterY)
        self.view.removeConstraint(self.L_LabelTrailing)
        self.view.removeConstraint(self.L_LabelLeading)
        
        self.view.addConstraint(self.ImageViewWidth)
        self.view.addConstraint(self.ImageViewHeight)
        self.view.addConstraint(self.ImageViewAspectRatio)
    }
    
    func applyFruitLandScapeConstraint(){
        self.view.removeConstraint(self.P_FirstViewTop)
        self.view.removeConstraint(self.P_FirstViewBottom_alt)
        self.view.removeConstraint(self.P_FirstViewLeading)
        self.view.removeConstraint(self.P_FirstViewTrailing)
        self.view.removeConstraint(self.P_SecondViewTop_alt)
        self.view.removeConstraint(self.P_SecondViewBottom)
        self.view.removeConstraint(self.P_SecondViewTrailing)
        self.view.removeConstraint(self.P_SecondViewLeading)
        self.view.removeConstraint(self.P_ImageViewTop)
        self.view.removeConstraint(self.P_ImageViewBottom)
        self.view.removeConstraint(self.P_ImageViewCenterX)
        self.view.removeConstraint(self.P_LabelCenterY)
        self.view.removeConstraint(self.P_LabelTrailing)
        self.view.removeConstraint(self.P_LabelLeading)
        
        self.view.addConstraint(self.L_FirstViewTop)
        self.view.addConstraint(self.L_FirstViewBottom)
        self.view.addConstraint(self.L_FirstViewLeading)
        self.view.addConstraint(self.L_FirstViewTrailing_alt)
        self.view.addConstraint(self.L_SecondViewTop)
        self.view.addConstraint(self.L_SecondViewBottom)
        self.view.addConstraint(self.L_SecondViewTrailing)
        self.view.addConstraint(self.L_SecondViewLeading)
        self.view.addConstraint(self.L_ImageViewCenterY)
        self.view.addConstraint(self.L_ImageViewTrailing)
        self.view.addConstraint(self.L_ImageViewLeading)
        self.view.addConstraint(self.L_LabelCenterY)
        self.view.addConstraint(self.L_LabelTrailing)
        self.view.addConstraint(self.L_LabelLeading)
        
        self.view.addConstraint(self.ImageViewWidth)
        self.view.addConstraint(self.ImageViewHeight)
        self.view.addConstraint(self.ImageViewAspectRatio)
    }
}

