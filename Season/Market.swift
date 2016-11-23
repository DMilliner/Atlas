//
//  Market.swift
//  Season
//
//  Created by David Milliner on 11/22/16.
//  Copyright © 2016 David Milliner. All rights reserved.
//

import UIKit
import CoreLocation

class Market {
    
    func getSeasonalFruits(_ unsortedFruits: [Fruits]) -> [Fruits]{
        let currentMonth = Calendar.current.component(.month, from: Date())
        var sl:[Fruits] = []
        for potentialSeasonalFruit in unsortedFruits {
            if(currentMonth>=potentialSeasonalFruit.startSeason && currentMonth<=potentialSeasonalFruit.endSeason){
                sl.append(potentialSeasonalFruit)
            }
        }
        return sl
    }
    
    func getPomeFruitsCompleteListbyLocation(location : String) -> [Fruits]{
        //Same fruit can have different season by Location
        print("-->  \(location)")
        var unsortedPomeFruitsOnlyList: [Fruits] = []

        switch location {
        case "Europe":
            unsortedPomeFruitsOnlyList.append(Fruits.init(name: "\u{1F34E}" + "Pomme",        startSeason: 1, endSeason: 11)!)
            unsortedPomeFruitsOnlyList.append(Fruits.init(name: "Chokeberry",          startSeason: 11, endSeason: 12)!)
            unsortedPomeFruitsOnlyList.append(Fruits.init(name: "\u{1F34F}" + "Pear",     startSeason: 1, endSeason: 4)!)
        default:
            unsortedPomeFruitsOnlyList.append(Fruits.init(name: "\u{1F34E}" + "Apple",        startSeason: 1, endSeason: 11)!)
            unsortedPomeFruitsOnlyList.append(Fruits.init(name: "Chokeberry",          startSeason: 11, endSeason: 12)!)
            unsortedPomeFruitsOnlyList.append(Fruits.init(name: "\u{1F34F}" + "Pear",     startSeason: 1, endSeason: 12)!)
        }
        
        return unsortedPomeFruitsOnlyList
    }
    func getStoneFruitsCompleteListbyLocation(location : String) -> [Fruits]{
        print("\(location)")
        return []
    }
    func getTemperateFruitsCompleteListbyLocation(location : String) -> [Fruits]{
        print("\(location)")
        return []
    }
    func getBerriesCompleteListbyLocation(location : String) -> [Fruits]{
        print("\(location)")
        return []
    }
    func getMediterraneanNativeFruitsCompleteListbyLocation(location : String) -> [Fruits]{
        print("\(location)")
        return []
    }
    func getCitrusCompleteListbyLocation(location : String) -> [Fruits]{
        print("\(location)")
        return []
    }
    func getSubTropicalFruitsCompleteListbyLocation(location : String) -> [Fruits]{
        print("\(location)")
        return []
    }
    func getTropicalFruitsCompleteListbyLocation(location : String) -> [Fruits]{
        print("\(location)")
        return []
    }
    func getFruitsCompleteListbyLocation(location : String) -> [String:[Fruits]]{
        print("\(location)")
        
        let fruitsCompleteList = ["Pome fruits": getPomeFruitsCompleteListbyLocation(location: location),
                                  "Stone fruits": getStoneFruitsCompleteListbyLocation(location: location),
                                  "Other temperate fruits": getTemperateFruitsCompleteListbyLocation(location: location),
                                  "Berries": getBerriesCompleteListbyLocation(location: location),
                                  "Mediterranean natives": getMediterraneanNativeFruitsCompleteListbyLocation(location: location),
                                  "Citrus": getCitrusCompleteListbyLocation(location: location),
                                  "Other subtropical fruits": getSubTropicalFruitsCompleteListbyLocation(location: location),
                                  "Tropical fruits": getTropicalFruitsCompleteListbyLocation(location: location)]
        
        return fruitsCompleteList
    }
    
    //Same but seasonal...

}
