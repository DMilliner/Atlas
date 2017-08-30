//
//  FruitsViewController.swift
//  Season
//
//  Created by David Milliner on 11/15/16.
//  Copyright © 2016 David Milliner. All rights reserved.
//

import UIKit

class FruitsViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var window: UIWindow?
    
    @IBOutlet var tableView: UITableView!
    
//    var detailViewController: FruitDetailViewController? = nil
    let cellReuseIdentifier = "cell"
    
    var dictionary: [String:[Fruits]] = [:]
    
    var seasonalFruitsList: [Fruits] = []
    
    var pomeFruitsOnlyList: [Fruits] = []
    var stoneFruitsOnlyList: [Fruits] = []
    var temperateFruitsOnlyList: [Fruits] = []
    var berriesOnlyList: [Fruits] = []
    var mediterraneanNativesOnlyList: [Fruits] = []
    var citrusOnlyList: [Fruits] = []
    var subtropicalfruitsOnlyList: [Fruits] = []
    var tropicalFruitsOnlyList: [Fruits] = []
    
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
        
        //Necessary for first run coming from Detail
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        dictionary.removeAll()
        objectArray.removeAll()
        dictionary = getSortedFruitsList()
        for (key, value) in dictionary {
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
        
//        if let split = self.splitViewController {
//            let controllers = split.viewControllers
//            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? FruitDetailViewController
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let iPathSection = UserDefaults.standard.integer(forKey: "fruitIndexPathSection")
        let iPathRow = UserDefaults.standard.integer(forKey: "fruitIndexPathRow")

        let iP = IndexPath(row: iPathRow, section: iPathSection)
        let rect = self.tableView.rectForRow(at: iP)
        if (iPathSection == 9999 && iPathRow == 9999){
            print("Initialize the view no Offset")
        } else {
            let point = CGPoint(x: rect.origin.x, y: rect.origin.y-25)
            self.tableView.setContentOffset(point, animated: false)
        }
        
        dictionary.removeAll()
        objectArray.removeAll()
        dictionary = getSortedFruitsList()
        for (key, value) in dictionary {
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
            print("\(objectArray.count)")
        }
        
        self.tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showFruitDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                if let cell = self.tableView.cellForRow(at: indexPath) {
//                    
//                    let controller = (segue.destination as! UINavigationController).topViewController as! FruitDetailViewController
//                    controller.fruitNameItem = cell.textLabel?.text
//                    controller.fruitSectionItem = objectArray[indexPath.section].sectionName
//                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
//                    controller.navigationItem.leftItemsSupplementBackButton = true
//                    tableView.deselectRow(at: indexPath, animated: true)
//                }
//            }
//        }
//    }
    
    // MARK: - Table View
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }
    
    // create a cell for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row].name
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.backgroundColor = UIColor.black

        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        UserDefaults.standard.set(indexPath.section, forKey: "fruitIndexPathSection")
        UserDefaults.standard.set(indexPath.row, forKey: "fruitIndexPathRow")
        UserDefaults.standard.synchronize()
        
//        performSegue(withIdentifier: "showFruitDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectArray[section].sectionName
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title: UILabel = UILabel()
        
        title.text = objectArray[section].sectionName
        title.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        title.font = UIFont.boldSystemFont(ofSize: 14.0)
        
        //        for family: String in UIFont.familyNames
        //        {
        //            print("\(family)")
        //            for names: String in UIFont.fontNames(forFamilyName: family)
        //            {
        //                print("== \(names)")
        //            }
        //        }
        //        title.font = UIFont(name: "SFUIDisplay-Ultralight", size: 15)
        title.textAlignment = .center
        return title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    func getSortedFruitsList() -> [String:[Fruits]]{
        return Market().getSeasonalFruitsCompleteListByLocation(location: UserDefaults.standard.string(forKey: "savedWorldRegion")!)
    }
}
