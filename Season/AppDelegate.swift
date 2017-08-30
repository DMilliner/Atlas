//
//  AppDelegate.swift
//  Season
//
//  Created by David Milliner on 11/15/16.
//  Copyright © 2016 David Milliner. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let rootController = storyboard.instantiateViewController(withIdentifier: "tabBarController")
//        if let window = self.window {
//            window.rootViewController = rootController
//        }
        
        if self.window!.rootViewController as? UITabBarController != nil {
            let tababarController = self.window!.rootViewController as! UITabBarController
            tababarController.selectedIndex = 1
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

//    // MARK: - Split view
//
//    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
//        
//        print("-AppDelegate splitViewController-")
////        guard let secondaryAsFruitNavController = secondaryViewController as? UINavigationController else { return false }
////        guard let topAsFruitDetailController = secondaryAsFruitNavController.topViewController as? FruitDetailViewController else { return false }
////        
////        guard let secondaryAsVegetableNavController = secondaryViewController as? UINavigationController else { return false }
////        guard let topAsVegetableDetailController = secondaryAsVegetableNavController.topViewController as? VegetableDetailViewController else { return false }
////        
////        if topAsVegetableDetailController.detailItem == nil {
////            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
////            return true
////        } else if topAsFruitDetailController.detailItem == nil {
////            return true
////        } else {
////            return false
////        }
//        return true
//    }
}

