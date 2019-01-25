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
    @IBOutlet var imageSeparatorView: UIView!
    @IBOutlet var imageSeparator2View: UIView!
    @IBOutlet var listInSeasonLabel: UILabel!


    var locationManager = CLLocationManager()
    var dictionary: [String:[Fruits]] = [:]
    struct Objects {
        var sectionName : String!
        var sectionObjects : [Fruits]!
    }
    var objectArray = [Objects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = UIColor.green

        locationLabel.text = "\u{1F310} Localized in : "
        locationLabel.textColor = UIColor.white

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
        super.viewWillAppear(animated)
        
        if let worldRegionExists = UserDefaults.standard.string(forKey: "savedWorldRegion") {
            self.locationLabel.text = emojiByRegion(worldRegionExists) + " Localized in : "
            self.locationValueLabel.text = worldRegionExists
        } else {
            self.locationLabel.text = emojiByRegion("World") + " Localized in : "
            self.locationValueLabel.text = "World"
            UserDefaults.standard.set("World", forKey: "savedWorldRegion")
            UserDefaults.standard.synchronize()
        }
        
        if UIDevice.current.orientation.isLandscape {
            print(" --- landscape")
            let gradient = CAGradientLayer()
            gradient.frame = self.imageSeparatorView.bounds
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            gradient.colors = [UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1).cgColor, UIColor(red: 164/255, green: 217/255, blue: 57/255, alpha: 1).cgColor]
            self.imageSeparatorView.layer.insertSublayer(gradient, at: 0)
            
            let gradient2 = CAGradientLayer()
            gradient2.frame = self.imageSeparatorView.bounds
            gradient2.startPoint = CGPoint(x: 0, y: 0)
            gradient2.endPoint = CGPoint(x: 1, y: 1)
            gradient2.colors = [UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1).cgColor, UIColor(red: 164/255, green: 217/255, blue: 57/255, alpha: 1).cgColor]
            self.imageSeparator2View.layer.insertSublayer(gradient2, at: 0)
        }
        
        if UIDevice.current.orientation.isPortrait {
            print(" --- Portrait")
            let gradient = CAGradientLayer()
            gradient.frame = self.imageSeparatorView.bounds
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            gradient.colors = [UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1).cgColor, UIColor(red: 164/255, green: 217/255, blue: 57/255, alpha: 1).cgColor]
            self.imageSeparatorView.layer.insertSublayer(gradient, at: 0)
            
            let gradient2 = CAGradientLayer()
            gradient2.frame = self.imageSeparatorView.bounds
            gradient2.startPoint = CGPoint(x: 0, y: 0)
            gradient2.endPoint = CGPoint(x: 1, y: 1)
            gradient2.colors = [UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1).cgColor, UIColor(red: 164/255, green: 217/255, blue: 57/255, alpha: 1).cgColor]
            self.imageSeparator2View.layer.insertSublayer(gradient2, at: 0)
        }
        
        var dictionary: [String:[Fruits]] = [:]
        dictionary.removeAll()
        dictionary = Market().getSeasonalFruitsCompleteListByLocation(location: UserDefaults.standard.string(forKey: "savedWorldRegion")!)
        objectArray.removeAll()
        for (key, value) in dictionary {
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
        
        
        var array : [String] = []
        var completeFruitListName : [String] = []
        var selectedArray : [String] = []

        for items in objectArray {
            print(items)
            for fruits in items.sectionObjects {
                print(fruits)
                array.append(fruits.name)
                completeFruitListName.append(fruits.name)
            }
        }
        
        for index in 0...9{
            let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
            print("\(index) -- \(array[randomIndex])")
            selectedArray.append(array[randomIndex])
            array.remove(at: randomIndex)
        }
        
        listInSeasonLabel.text = selectedArray.joined(separator: ", ")
        
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            if UIDevice.current.orientation.isLandscape {
                print(" --- landscape")
                let gradient = CAGradientLayer()
                gradient.frame = self.imageSeparatorView.bounds
                gradient.startPoint = CGPoint(x: 0, y: 0)
                gradient.endPoint = CGPoint(x: 1, y: 1)
                gradient.colors = [UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1).cgColor, UIColor(red: 164/255, green: 217/255, blue: 57/255, alpha: 1).cgColor]
                self.imageSeparatorView.layer.insertSublayer(gradient, at: 0)
                
                let gradient2 = CAGradientLayer()
                gradient2.frame = self.imageSeparatorView.bounds
                gradient2.startPoint = CGPoint(x: 0, y: 0)
                gradient2.endPoint = CGPoint(x: 1, y: 1)
                gradient2.colors = [UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1).cgColor, UIColor(red: 164/255, green: 217/255, blue: 57/255, alpha: 1).cgColor]
                self.imageSeparator2View.layer.insertSublayer(gradient2, at: 0)
            }
            
            if UIDevice.current.orientation.isPortrait {
                print(" --- Portrait")
                let gradient = CAGradientLayer()
                gradient.frame = self.imageSeparatorView.bounds
                gradient.startPoint = CGPoint(x: 0, y: 0)
                gradient.endPoint = CGPoint(x: 1, y: 1)
                gradient.colors = [UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1).cgColor, UIColor(red: 164/255, green: 217/255, blue: 57/255, alpha: 1).cgColor]
                self.imageSeparatorView.layer.insertSublayer(gradient, at: 0)
                
                let gradient2 = CAGradientLayer()
                gradient2.frame = self.imageSeparatorView.bounds
                gradient2.startPoint = CGPoint(x: 0, y: 0)
                gradient2.endPoint = CGPoint(x: 1, y: 1)
                gradient2.colors = [UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1).cgColor, UIColor(red: 164/255, green: 217/255, blue: 57/255, alpha: 1).cgColor]
                self.imageSeparator2View.layer.insertSublayer(gradient2, at: 0)
            }
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            print("rotation completed")
        })
        super.viewWillTransition(to: size, with: coordinator)
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
            
            if(self.isInternetAvailable() && placemarks?[0] != nil){
                placeMark = placemarks?[0]
                print("dictionary = \(String(describing: placeMark.addressDictionary))")
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
        })
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        let lError = error as! CLError
        if(lError.code == CLError.locationUnknown || lError.code == CLError.denied){
            if let worldRegionExists = UserDefaults.standard.string(forKey: "savedWorldRegion") {
                self.locationLabel.text = emojiByRegion(worldRegionExists) + " Localized in : "
                self.locationValueLabel.text = worldRegionExists
            } else {
                self.locationLabel.text = emojiByRegion("World") + " Localized in : "
                self.locationValueLabel.text = "World"
                UserDefaults.standard.set("World", forKey: "savedWorldRegion")
                UserDefaults.standard.synchronize()
            }
        } else {
            self.locationLabel.text = emojiByRegion("World") + " Localized in : "
            self.locationValueLabel.text = "World"
            UserDefaults.standard.set("World", forKey: "savedWorldRegion")
            UserDefaults.standard.synchronize()
        }
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
