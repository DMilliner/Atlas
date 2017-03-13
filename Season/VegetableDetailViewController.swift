//
//  VegetableDetailViewController.swift
//  Season
//
//  Created by David Milliner on 11/15/16.
//  Copyright © 2016 David Milliner. All rights reserved.
//

import UIKit

class VegetableDetailViewController: UIViewController {
    var window: UIWindow?

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var vegetableImage: UIImageView!

    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            print("--> detail " + detail.description)
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
                //self.title = detail.description
                self.navigationItem.title = detail.description
            }
        } else {
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "vegetablesList") as UIViewController, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = UIColor.green
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
