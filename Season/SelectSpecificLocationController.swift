//
//  SelectSpecificLocationController.swift
//  Season
//
//  Created by David Milliner on 12/5/16.
//  Copyright © 2016 David Milliner. All rights reserved.
//

import UIKit


class SelectSpecificLocationController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var selectLocationLabel: UILabel!
    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet var selectedLocationLabel: UILabel!
    @IBOutlet var selectedLocationImage: UIImageView!

    var data : String = ""
    let pickerData = ["North America", "South America", "Europe", "Africa", "Asia", "Oceania", "World"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectLocationLabel.text = "Please select your desired location : "
        locationPicker.dataSource = self
        locationPicker.delegate = self
        
        if let indexOfLocation = pickerData.index(of: data) {
            self.locationPicker.selectRow(indexOfLocation, inComponent: 0, animated: true)
        }
        selectedLocationLabel.text = "Location selected is " + data
        selectedLocationImage.image = imageByLocation(data)
    }
    
    @IBAction func unwindToPreviousViewController(sender: AnyObject){
        print("Unwind")
        dismiss(animated: true, completion: nil)
    }
    
//MARK: - Delegates and data sources
    
    //MARK: Data Sources
    func numberOfComponents(in: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLocationLabel.text = "Location selected is " + pickerData[row]
        UserDefaults.standard.synchronize()
        switch pickerData[row] {
        case "North America":
            selectedLocationImage.image = UIImage(named: "northAmerica")
            UserDefaults.standard.set("North America", forKey: "savedWorldRegion")
            UserDefaults.standard.synchronize()
            break
        case "South America":
            selectedLocationImage.image = UIImage(named: "southAmerica")
            UserDefaults.standard.set("South America", forKey: "savedWorldRegion")
            UserDefaults.standard.synchronize()
            break
        case "Europe":
            selectedLocationImage.image = UIImage(named: "europe")
            UserDefaults.standard.set("Europe", forKey: "savedWorldRegion")
            UserDefaults.standard.synchronize()
            break
        case "Africa":
            selectedLocationImage.image = UIImage(named: "africa")
            UserDefaults.standard.set("Africa", forKey: "savedWorldRegion")
            UserDefaults.standard.synchronize()
            break
        case "Asia":
            selectedLocationImage.image = UIImage(named: "asia")
            UserDefaults.standard.set("Asia", forKey: "savedWorldRegion")
            UserDefaults.standard.synchronize()
            break
        case "Oceania":
            selectedLocationImage.image = UIImage(named: "oceania")
            UserDefaults.standard.set("Oceania", forKey: "savedWorldRegion")
            UserDefaults.standard.synchronize()
            break
        case "World":
            selectedLocationImage.image = UIImage(named: "world")
            UserDefaults.standard.set("World", forKey: "savedWorldRegion")
            UserDefaults.standard.synchronize()
            break
        default:
            break
        }
    }
    
    func imageByLocation(_ location: String)-> UIImage{
        
        var uiImageToReturn: UIImage? = nil
        switch location {
        case "North America":
            uiImageToReturn = UIImage(named: "northAmerica")
            break
        case "South America":
            uiImageToReturn = UIImage(named: "southAmerica")
            break
        case "Europe":
            uiImageToReturn = UIImage(named: "europe")
            break
        case "Africa":
            uiImageToReturn = UIImage(named: "africa")
            break
        case "Asia":
            uiImageToReturn = UIImage(named: "asia")
            break
        case "Oceania":
            uiImageToReturn = UIImage(named: "oceania")
            break
        case "World":
            uiImageToReturn = UIImage(named: "world")
            break
        default:
            uiImageToReturn = nil
            break
        }
        
        return uiImageToReturn!
    }
}
