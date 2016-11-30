//
//  Fruits.swift
//  Season
//
//  Created by David Milliner on 11/16/16.
//  Copyright © 2016 David Milliner. All rights reserved.
//

import Foundation
import UIKit


class Fruits {
    // MARK: Properties
    
    var name: String = ""
    var startSeason: Int = 0
    var endSeason: Int = 0
    
    // MARK: Initialization
    init?(name: String, startSeason: Int, endSeason: Int) {
        // Initialize stored properties.
        self.name = name
        self.startSeason = startSeason
        self.endSeason = endSeason
        
        // Initialization should fail if there is no name or if the rating is negative.
        if (name.isEmpty ||
            startSeason <= 0 || startSeason > 12 ||
            endSeason <= 0   || endSeason > 12) {
            return nil
        }
    }
    
    
}
