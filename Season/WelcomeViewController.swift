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

    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var locationValueLabel: UILabel!
    @IBOutlet var locationView: UIView!

    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        locationLabel.text = "\u{1F310} Localized in : "
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(WelcomeViewController.selectSpecificLocation))
        locationView.isUserInteractionEnabled = true
        locationView.addGestureRecognizer(tapGestureRecognizer)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        if let worldRegionExists = UserDefaults.standard.string(forKey: "savedWorldRegion") {
            self.locationLabel.text = emojiByRegion(worldRegionExists) + " Localized in : "
            self.locationValueLabel.text = worldRegionExists
        } else {
            self.locationLabel.text = emojiByRegion("World") + " Localized in : "
            self.locationValueLabel.text = "World"
            UserDefaults.standard.set("World", forKey: "savedWorldRegion")
            UserDefaults.standard.synchronize()
        }
    }
    
    func selectSpecificLocation(){
        self.performSegue(withIdentifier: "selectSpecificLocation", sender: self)
        locationManager.stopUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectSpecificLocation" {
            let svc = segue.destination as? UINavigationController
            let controller: SelectSpecificLocationController = svc?.topViewController as! SelectSpecificLocationController
            controller.data = UserDefaults.standard.string(forKey: "savedWorldRegion")!
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
        
        var region: String = ""
        var country: String = ""
        var worldRegion: String = "World"
        var emojiRegion: String = "\u{1F310}"
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var placeMark: CLPlacemark!
            
            if(self.isInternetAvailable()){
                placeMark = placemarks?[0]
                print("dictionary = \(placeMark.addressDictionary)")
                //let region = (placeMark.timeZone?.identifier)! as String
                
                region = (placeMark.timeZone?.description)!
                country = (placeMark.country?.description)!
                
                print("region : \(region)")
                print("country : \(country)")
                
                
                if((region.range(of: "Europe")) != nil){
                    print("World region = Europe")
                    worldRegion = "Europe"
                    emojiRegion = "\u{1F30D}"
                    
                } else if((region.range(of: "Africa")) != nil){
                    print("World region = Africa")
                    worldRegion = "Africa"
                    emojiRegion = "\u{1F30D}"
                    
                } else if((region.range(of: "Asia")) != nil){
                    print("World region = Asia")
                    worldRegion = "Asia"
                    emojiRegion = "\u{1F30F}"
                    
                } else if((region.range(of: "Australia")) != nil){
                    print("World region = Oceania")
                    worldRegion = "Oceania"
                    emojiRegion = "\u{1F30F}"
                    
                } else if((region.range(of: "America")) != nil){
                    emojiRegion = "\u{1F30E}"
                    
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
                    emojiRegion = "\u{1F30F}"
                    
                } else {
                    print("World region = somewhere else...")
                    emojiRegion = "\u{1F310}"
                    
                }
                UserDefaults.standard.set(worldRegion, forKey: "savedWorldRegion")
                UserDefaults.standard.synchronize()
                
            } else {
                print("No Internet")
                emojiRegion = "\u{1F310}"
                worldRegion = UserDefaults.standard.string(forKey: "savedWorldRegion")!
            }
            
            self.locationLabel.text = emojiRegion + " Localized in : "
            self.locationValueLabel.text = worldRegion + " \(country)"
            
            //            for element in Market().getPomeFruitsCompleteListbyLocation(location: worldRegion) {
            //                print("Sooooooo \(element.name)")
            //            }
        })
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        self.locationLabel.text = emojiByRegion("World") + " Localized in : "
        self.locationValueLabel.text = "World"
        UserDefaults.standard.set("World", forKey: "savedWorldRegion")
        UserDefaults.standard.synchronize()
    }
    
    func emojiByRegion(_ location :String)->String{
        var emojiToReturn = "\u{1F310}"
        switch location {
        case "North America":
            emojiToReturn = "\u{1F30E}"
            break
        case "South America":
            emojiToReturn = "\u{1F30E}"
            break
        case "Europe":
            emojiToReturn = "\u{1F30D}"
            break
        case "Africa":
            emojiToReturn = "\u{1F30D}"
            break
        case "Asia":
            emojiToReturn = "\u{1F30F}"
            break
        case "Oceania":
            emojiToReturn = "\u{1F30F}"
            break
        case "World":
            emojiToReturn = "\u{1F310}"
            break
        default:
            emojiToReturn = "\u{1F310}"
            break
        }
        return emojiToReturn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
