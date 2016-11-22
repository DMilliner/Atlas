//
//  WelcomeViewController.swift
//  Season
//
//  Created by David Milliner on 11/17/16.
//  Copyright © 2016 David Milliner. All rights reserved.
//

import UIKit
import CoreLocation

class WelcomeViewController: UIViewController, CLLocationManagerDelegate {
    var window: UIWindow?

    @IBOutlet var welcomeLabel: UILabel!
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        welcomeLabel.text = "Welcome to Season"
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
//            print("dictionary = \(placeMark.addressDictionary)")
//            let region = (placeMark.timeZone?.identifier)! as String
            let region = placeMark.timeZone?.description
            let country = placeMark.country?.description
            
            if let region = region {
                print("timeZone description = \(region)")
                print("country description = \(country)")

                if((region.range(of: "Europe")) != nil){
                    print("World region = Europe")
                    
                } else if((region.range(of: "Africa")) != nil){
                    print("World region = Africa")
                    
                } else if((region.range(of: "Asia")) != nil){
                    print("World region = Asia")
                    
                } else if((region.range(of: "Australia")) != nil){
                    print("World region = Australia")
                    
                } else if((region.range(of: "America")) != nil){
                    let northAmerica = ["Canada", "Mexico", "United States"]
                    let centralAmerica = ["Belize", "Costa Rica", "El Salvador", "Guatemala", "Honduras", "Nicaragua", "Panama"]
                    let southAmerica = ["Argentina", "Bolivia", "Brazil", "Chile", "Colombia", "Ecuador", "French Guinea", "Guyana", "Paraguay", "Peru", "Surinam", "Venezuela", "Uruguay"]
                    
                    if(northAmerica.contains(country!)){
                        print("World region = North America")
                    } else if(centralAmerica.contains(country!)){
                        print("World region = Central America")
                    } else if(southAmerica.contains(country!)){
                        print("World region = South America")
                    } else {
                        print("World region = America")
                    }
                } else {
                    print("World region = somewhere else...")
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
