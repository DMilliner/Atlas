//
//  CustomTabBarController.swift
//  Season
//
//  Created by David Milliner on 11/15/16.
//  Copyright © 2016 David Milliner. All rights reserved.
//

import Foundation
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class CustomTabBarController: UITabBarController, UINavigationControllerDelegate {
    //UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource
    let seasonGreen = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
    let seasonGrey =  UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)

        self.tabBar.layer.borderWidth = 0
        self.tabBar.clipsToBounds = true
        
        UITabBar.appearance().barTintColor = UIColor.black

        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: seasonGreen], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: seasonGrey], for: .normal)
        
        for item in self.tabBar.items! {
            if let image = item.image {
                item.image = image.imageWithColor(seasonGrey).withRenderingMode(.alwaysOriginal)
            }
            if let selectedImage = item.selectedImage {
                item.selectedImage = selectedImage.imageWithColor(seasonGreen).withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.title! {
        case "Vegetables":
            print("Vegetables")
            UserDefaults.standard.set(9999, forKey: "fruitIndexPathSection")
            UserDefaults.standard.set(9999, forKey: "fruitIndexPathRow")
            UserDefaults.standard.synchronize()
            print("Saved")
        case "Welcome":
            print("Welcome")
            UserDefaults.standard.set(9999, forKey: "vegetableIndexPathSection")
            UserDefaults.standard.set(9999, forKey: "vegetableIndexPathRow")
            UserDefaults.standard.set(9999, forKey: "fruitIndexPathSection")
            UserDefaults.standard.set(9999, forKey: "fruitIndexPathRow")
            UserDefaults.standard.synchronize()
            print("Saved")
        case "Fruits":
            print("Fruits")
            UserDefaults.standard.set(9999, forKey: "vegetableIndexPathSection")
            UserDefaults.standard.set(9999, forKey: "vegetableIndexPathRow")
            UserDefaults.standard.synchronize()
            print("Saved")
        default:
            print("default")
            UserDefaults.standard.set(9999, forKey: "vegetableIndexPathSection")
            UserDefaults.standard.set(9999, forKey: "vegetableIndexPathRow")
            UserDefaults.standard.set(9999, forKey: "fruitIndexPathSection")
            UserDefaults.standard.set(9999, forKey: "fruitIndexPathRow")
            UserDefaults.standard.synchronize()
            print("Saved")
            break
        }
    }
}

//Extending UI Image class
extension UIImage {
    func imageWithColor(_ tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0);
        context!.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context!.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context!.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
