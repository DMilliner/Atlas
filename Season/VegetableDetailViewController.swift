//
//  VegetableDetailViewController.swift
//  Season
//
//  Created by David Milliner on 11/15/16.
//  Copyright © 2016 David Milliner. All rights reserved.
//

import UIKit

class VegetableDetailViewController: UIViewController {
    var window: UIWindow?

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var vegetableImage: UIImageView!

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
    

    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            print("--> detail " + detail.description)
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
                //self.title = detail.description
                self.navigationItem.title = detail.description
            }
        } else {
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "vegetablesList") as UIViewController, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FruitDetailViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func rotated() {
        if UIDevice.current.orientation.isLandscape {
            print(" --- landscape")
            applyLandScapeConstraint()
        }
        
        if UIDevice.current.orientation.isPortrait {
            print(" --- Portrait")
            applyPortraitConstraint()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
//        // if landscape
//        if UIInterfaceOrientationIsLandscape(toInterfaceOrientation) {
//            print("--  -F- wR --  landscape")
//            self.applyLandScapeConstraint()
//        } else { // else portrait
//            print("-- portrait")
//            self.applyPortraitConstraint()
//        }
//    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in

            if UIDevice.current.orientation.isLandscape {
                print(" --- landscape")
                self.applyLandScapeConstraint()
            }
            
            if UIDevice.current.orientation.isPortrait {
                print(" --- Portrait")
                self.applyPortraitConstraint()
            }
            
//            let orient = UIApplication.shared.statusBarOrientation
//            
//            switch orient {
//            case .portrait:
//                print("Portrait")
//                self.applyPortraitConstraint()
//                break
//            default:
//                print("LandScape")
//                self.applyLandScapeConstraint()
//                break
//            }
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            print("rotation completed")
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func applyPortraitConstraint(){
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
    
    func applyLandScapeConstraint(){
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
