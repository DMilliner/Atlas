//
//  FruitDetailViewController.swift
//  Season
//
//  Created by David Milliner on 11/15/16.
//  Copyright © 2016 David Milliner. All rights reserved.
//

import UIKit

class FruitDetailViewController: UIViewController {

    @IBOutlet weak var fruitNameLabel: UILabel!
    @IBOutlet weak var fruitImage: UIImageView!

    func configureNameView() {
        // Update the user interface for the detail item.
        if let fruitName = self.fruitNameItem {
            print("-> Fruit Name " + fruitName.description)
            if let label = self.fruitNameLabel {
                label.text = fruitName.description
            }
        }else {
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "fruitsList") as UIViewController, animated: false)
        }
    }
    
    func configureImageView() {
        // Update the user interface for the detail item.
        if let fruitSection = self.fruitSectionItem {
            print("-> Fruit Section " + fruitSection.description)
            if let image = self.fruitImage {
                
                if(fruitSection == "Berries"){
                    image.backgroundColor = UIColor.init(red: 30/255.0, green: 90/255.0, blue: 225/255.0, alpha: 1.0)
                } else {
                    image.backgroundColor = UIColor.init(red: 245/255.0, green: 90/255.0, blue: 65/255.0, alpha: 1.0)
                }
                
            }
        }else {
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "fruitsList") as UIViewController, animated: false)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureNameView()
        self.configureImageView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var fruitNameItem: String? {
        didSet {
            // Update the view.
            self.configureNameView()
        }
    }
    
    var fruitSectionItem: String? {
        didSet {
            // Update the view.
            self.configureImageView()
        }
    }
}

