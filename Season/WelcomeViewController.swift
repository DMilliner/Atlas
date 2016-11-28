//
//  WelcomeViewController.swift
//  Season
//
//  Created by David Milliner on 11/17/16.
//  Copyright © 2016 David Milliner. All rights reserved.
//

import UIKit
import CoreLocation
import SystemConfiguration


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
    
    func isInternetAvailable() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        // save the location
        // if they have changed reverseGeocode
        // else skip
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var placeMark: CLPlacemark!
            var region: String = ""
            var country: String = ""
            var worldRegion: String = "World"

            placeMark = placemarks?[0]
            
            if(self.isInternetAvailable()){

                print("dictionary = \(placeMark.addressDictionary)")
                //let region = (placeMark.timeZone?.identifier)! as String
                
                region = (placeMark.timeZone?.description)!
                country = (placeMark.country?.description)!
                
                print("region : \(region)")
                print("country : \(country)")
                

                if((region.range(of: "Europe")) != nil){
                    print("World region = Europe")
                    worldRegion = "Europe"
                        
                } else if((region.range(of: "Africa")) != nil){
                    print("World region = Africa")
                    worldRegion = "Africa"
                        
                } else if((region.range(of: "Asia")) != nil){
                    print("World region = Asia")
                    worldRegion = "Asia"
                        
                } else if((region.range(of: "Australia")) != nil){
                    print("World region = Oceania")
                    worldRegion = "Oceania"
                        
                } else if((region.range(of: "America")) != nil){
                    let northAmerica = ["Canada", "Mexico", "United States"]
                    let centralAmerica = ["Belize", "Costa Rica", "El Salvador", "Guatemala", "Honduras", "Nicaragua", "Panama", "Bahamas", "Barbados", "Cuba", "Dominican Republic", "Grenada", "Haiti", "Jamaica", "Trinidad Tobago"]
                    let southAmerica = ["Argentina", "Bolivia", "Brazil", "Chile", "Colombia", "Ecuador", "French Guinea", "Guyana", "Paraguay", "Peru", "Surinam", "Venezuela", "Uruguay"]
                        
                    if(northAmerica.contains(country)){
                        print("World region = North America")
                        worldRegion = "North America"
                    } else if(centralAmerica.contains(country)){
                        print("World region = Central America")
                        worldRegion = "Central America"
                    } else if(southAmerica.contains(country)){
                        print("World region = South America")
                        worldRegion = "South America"
                    }
                } else if((region.range(of: "Pacific")) != nil){
                    print("World region = Pacific == Oceania")
                    worldRegion = "Oceania"
                } else {
                    print("World region = somewhere else...")
                }
            } else {
                print("No Internet")
            }
            
            self.welcomeLabel.text = "Welcome to Season" + " in " + worldRegion + " ("+country+")."
            print("Country : \(country)")
            UserDefaults.standard.set(worldRegion, forKey: "savedWorldRegion")
            
//            for element in Market().getPomeFruitsCompleteListbyLocation(location: worldRegion) {
//                print("Sooooooo \(element.name)")
//            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
