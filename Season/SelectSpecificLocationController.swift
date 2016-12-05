//
//  SelectSpecificLocationController.swift
//  Season
//
//  Created by David Milliner on 12/5/16.
//  Copyright © 2016 David Milliner. All rights reserved.
//

import UIKit
import CoreLocation
import SystemConfiguration


class SelectSpecificLocationController: UIViewController {

    var data : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("data from ReceiveViewController is \(data)")
    }
}
