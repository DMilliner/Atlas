//
//  VegetablesViewController.swift
//  Season
//
//  Created by David Milliner on 11/15/16.
//  Copyright © 2016 David Milliner. All rights reserved.
//

import UIKit

class VegetablesViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var window: UIWindow?
    
    // MARK: Properties
    @IBOutlet var tableView: UITableView!
    
//    var detailViewController: VegetableDetailViewController? = nil
    let cellReuseIdentifier = "cell"
    
    var dictionary: [String:[Vegetables]] = [:]

    var anyVegetablesList: [Vegetables] = []
    
    var vegetablesOnlyList: [Vegetables] = []
    var legumesOnlyList: [Vegetables] = []
    var herbsSpiciesOnlyList: [Vegetables] = []
    var onionsOnlyList: [Vegetables] = []
    var peppersOnlyList: [Vegetables] = []
    var rootVegetablesOnlyList: [Vegetables] = []
    var radishesOnlyList: [Vegetables] = []
    var squashesOnlyList: [Vegetables] = []
    var tubersOnlyList: [Vegetables] = []
    
    struct Objects {
        var sectionName : String!
        var sectionObjects : [Vegetables]!
    }
    var objectArray = [Objects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = UIColor.green
        
        //Necessary for first run coming from Detail
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        dictionary = getSortedVegetablesList()
        for (key, value) in dictionary {
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
        
//        if let split = self.splitViewController {
//            let controllers = split.viewControllers
//            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? VegetableDetailViewController
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let iPathSection = UserDefaults.standard.integer(forKey: "vegetableIndexPathSection")
        let iPathRow = UserDefaults.standard.integer(forKey: "vegetableIndexPathRow")
        
        let iP = IndexPath(row: iPathRow, section: iPathSection)
        let rect = self.tableView.rectForRow(at: iP)
        if (iPathSection == 9999 && iPathRow == 9999){
            print("Initialize the view no Offset")
        } else {
            let point = CGPoint(x: rect.origin.x, y: rect.origin.y-25)
            self.tableView.setContentOffset(point, animated: false)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getSeasonalVegetables(_ unsortedVeg: [Vegetables]) -> [Vegetables]{
        let currentMonth = Calendar.current.component(.month, from: Date())
        var sl:[Vegetables] = []
        for potentialSeasonalVegetable in unsortedVeg {
            //---- print name start end ----

            if(potentialSeasonalVegetable.startSeason < potentialSeasonalVegetable.endSeason){
                if(currentMonth>=potentialSeasonalVegetable.startSeason && currentMonth<=potentialSeasonalVegetable.endSeason){
                    sl.append(potentialSeasonalVegetable)
                }
            } else {
                if(currentMonth>=potentialSeasonalVegetable.startSeason && currentMonth<=potentialSeasonalVegetable.endSeason){
                    print("Not in season")
                } else {
                    sl.append(potentialSeasonalVegetable)
                }
            }
        }
        return sl
    }
    
    // MARK: - Segues
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showVegetableDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                if let cell = self.tableView.cellForRow(at: indexPath) {
//                    print("Content  Name " + (dictionary[objectArray[indexPath.section].sectionName]?[indexPath.row].name)!)
//                    let controller = (segue.destination as! UINavigationController).topViewController as! VegetableDetailViewController
//                    controller.detailItem = cell.textLabel?.text
//                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
//                    controller.navigationItem.leftItemsSupplementBackButton = true
//                    tableView.deselectRow(at: indexPath, animated: false)
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
//        if(objectArray[indexPath.section].sectionName == "Vegetables"){
//            cell.cellImage.backgroundColor = UIColor.init(red: 30/255.0, green: 90/255.0, blue: 225/255.0, alpha: 1.0)
//        } else {
//            cell.cellImage.backgroundColor = UIColor.init(red: 245/255.0, green: 90/255.0, blue: 65/255.0, alpha: 1.0)
//        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.section, forKey: "vegetableIndexPathSection")
        UserDefaults.standard.set(indexPath.row, forKey: "vegetableIndexPathRow")
        UserDefaults.standard.synchronize()
        print("Saved")
        
        var name: String = objectArray[indexPath.section].sectionObjects[indexPath.row].name
        let arr = name.characters.split{" \u{00A0}".characters.contains($0)}.map(String.init)
        var finalName: String = arr[0]
        if(arr.count >= 2){
            for i in 1..<arr.count{
                finalName = finalName+"_"+arr[i]
            }
        }

        UIApplication.shared.openURL(NSURL(string: "https://en.wikipedia.org/wiki/" + finalName)! as URL)
        tableView.deselectRow(at: indexPath, animated: true)
//        performSegue(withIdentifier: "showVegetableDetail", sender: self)
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
    
    func getSortedVegetablesList() -> [String:[Vegetables]]{
        anyVegetablesList.removeAll()
        
        vegetablesOnlyList.removeAll()
        legumesOnlyList.removeAll()
        herbsSpiciesOnlyList.removeAll()
        onionsOnlyList.removeAll()
        peppersOnlyList.removeAll()
        rootVegetablesOnlyList.removeAll()
        radishesOnlyList.removeAll()
        squashesOnlyList.removeAll()
        tubersOnlyList.removeAll()
        
        var unsortedVegetablesOnlyList: [Vegetables] = []
        var unsortedLegumesOnlyList: [Vegetables] = []
        var unsortedHerbsSpiciesOnlyList: [Vegetables] = []
        var unsortedOnionsOnlyList: [Vegetables] = []
        var unsortedPeppersOnlyList: [Vegetables] = []
        var unsortedRootVegetablesOnlyList: [Vegetables] = []
        var unsortedRadishesOnlyList: [Vegetables] = []
        var unsortedSquashesOnlyList: [Vegetables] = []
        var unsortedTubersOnlyList: [Vegetables] = []
        
        // -------------- Vegetables --------------
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Artichoke",        startSeason: 3, endSeason: 5)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Arugula",          startSeason: 1, endSeason: 12)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Asparagus",        startSeason: 5, endSeason: 6)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Amaranth",         startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Bok choy",         startSeason: 12, endSeason: 2)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Romanesco broccoli", startSeason: 9, endSeason: 12)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Broccoli",         startSeason: 6, endSeason: 11)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Brussels sprouts", startSeason: 9, endSeason: 3)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Cabbage",          startSeason: 1, endSeason: 12)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Calabrese",        startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Carrots",          startSeason: 7, endSeason: 3)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Cauliflower",      startSeason: 1, endSeason: 12)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Celery",           startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Chard",            startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Collard greens",   startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Corn",             startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Eggplant",         startSeason: 5, endSeason: 8)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Endive",           startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Fiddleheads",      startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Frisee",           startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Fennel",           startSeason: 7, endSeason: 10)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Kale",             startSeason: 9, endSeason: 3)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Kohlrabi",         startSeason: 7, endSeason: 10)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Lettuce", startSeason: 1, endSeason: 12)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Mushrooms",        startSeason: 1, endSeason: 12)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Mustard greens",   startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Nettles",          startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "New Zealand spinach", startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Okra",             startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Parsley",          startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Rhubarb",          startSeason: 4, endSeason: 9)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Salsify",          startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Skirret",          startSeason: 1, endSeason: 4)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Spinach",          startSeason: 5, endSeason: 10)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Topinambur",       startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Tat soi",          startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Tomato",           startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Turnip greens",    startSeason: 6, endSeason: 1)!)
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Water chestnut",   startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Watercress",       startSeason: 1, endSeason: 4)!)//
        unsortedVegetablesOnlyList.append(Vegetables.init(name: "Zucchini",         startSeason: 7, endSeason: 9)!)
        
        // -------------- Legumes --------------
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Alfalfa sprouts",     startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Azuki beans",         startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Bean sprouts",        startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Black beans",         startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Black-eyed peas",     startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Borlotti bean",       startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Broad beans",         startSeason: 6, endSeason: 8)!)
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Chickpeas",           startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Green beans",         startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Kidney beans",        startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Lentils",             startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Lima beans",          startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Mung beans",          startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Navy beans",          startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Pinto beans",         startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Runner beans",        startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Split peas",          startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Soy beans",           startSeason: 1, endSeason: 4)!)//
        unsortedLegumesOnlyList.append(Vegetables.init(name: "Peas",                startSeason: 7, endSeason: 9)!)

        // -------------- Herbs and spices --------------
        unsortedHerbsSpiciesOnlyList.append(Vegetables.init(name: "Anise",         startSeason: 1, endSeason: 12)!)//
        unsortedHerbsSpiciesOnlyList.append(Vegetables.init(name: "Basil",         startSeason: 5, endSeason: 11)!)
        unsortedHerbsSpiciesOnlyList.append(Vegetables.init(name: "Caraway",       startSeason: 1, endSeason: 4)!)//
        unsortedHerbsSpiciesOnlyList.append(Vegetables.init(name: "Cilantro",      startSeason: 6, endSeason: 9)!)
        unsortedHerbsSpiciesOnlyList.append(Vegetables.init(name: "Chamomile",     startSeason: 1, endSeason: 4)!)//
        unsortedHerbsSpiciesOnlyList.append(Vegetables.init(name: "Dill",          startSeason: 6, endSeason: 10)!)
        unsortedHerbsSpiciesOnlyList.append(Vegetables.init(name: "Fennel",        startSeason: 7, endSeason: 10)!)
        unsortedHerbsSpiciesOnlyList.append(Vegetables.init(name: "Lavender",      startSeason: 1, endSeason: 4)!)//
        unsortedHerbsSpiciesOnlyList.append(Vegetables.init(name: "Lemon Grass",   startSeason: 1, endSeason: 4)!)//
        unsortedHerbsSpiciesOnlyList.append(Vegetables.init(name: "Marjoram",      startSeason: 1, endSeason: 4)!)//
        unsortedHerbsSpiciesOnlyList.append(Vegetables.init(name: "Oregano",       startSeason: 1, endSeason: 4)!)//
        unsortedHerbsSpiciesOnlyList.append(Vegetables.init(name: "Parsley",       startSeason: 4, endSeason: 12)!)
        unsortedHerbsSpiciesOnlyList.append(Vegetables.init(name: "Rosemary",      startSeason: 1, endSeason: 4)!)//
        unsortedHerbsSpiciesOnlyList.append(Vegetables.init(name: "Sage",          startSeason: 3, endSeason: 12)!)
        unsortedHerbsSpiciesOnlyList.append(Vegetables.init(name: "Thyme",         startSeason: 3, endSeason: 12)!)

        // -------------- Onions --------------
        unsortedOnionsOnlyList.append(Vegetables.init(name: "Chives",              startSeason: 6, endSeason: 10)!)
        unsortedOnionsOnlyList.append(Vegetables.init(name: "Garlic",              startSeason: 1, endSeason: 4)!)//
        unsortedOnionsOnlyList.append(Vegetables.init(name: "Leek",                startSeason: 9, endSeason: 3)!)
        unsortedOnionsOnlyList.append(Vegetables.init(name: "Onion",               startSeason: 8, endSeason: 10)!)
        unsortedOnionsOnlyList.append(Vegetables.init(name: "Shallot",             startSeason: 6, endSeason: 8)!)
        unsortedOnionsOnlyList.append(Vegetables.init(name: "Green onion",         startSeason: 1, endSeason: 4)!)//

        // -------------- Peppers --------------
        unsortedPeppersOnlyList.append(Vegetables.init(name: "Bell pepper",         startSeason: 5, endSeason: 10)!)
        unsortedPeppersOnlyList.append(Vegetables.init(name: "Chili pepper",        startSeason: 1, endSeason: 4)!)//
        unsortedPeppersOnlyList.append(Vegetables.init(name: "Jalapeño",            startSeason: 1, endSeason: 4)!)//
        unsortedPeppersOnlyList.append(Vegetables.init(name: "Habanero",            startSeason: 1, endSeason: 4)!)//
        unsortedPeppersOnlyList.append(Vegetables.init(name: "Paprika",             startSeason: 1, endSeason: 4)!)//
        unsortedPeppersOnlyList.append(Vegetables.init(name: "Tabasco pepper",      startSeason: 1, endSeason: 4)!)//
        unsortedPeppersOnlyList.append(Vegetables.init(name: "Cayenne pepper",      startSeason: 1, endSeason: 4)!)//

        // -------------- Root Vegetables --------------
        unsortedRootVegetablesOnlyList.append(Vegetables.init(name: "Beet",         startSeason: 1, endSeason: 12)!)
        unsortedRootVegetablesOnlyList.append(Vegetables.init(name: "Carrot",       startSeason: 1, endSeason: 4)!)
        unsortedRootVegetablesOnlyList.append(Vegetables.init(name: "Celeriac",     startSeason: 1, endSeason: 4)!)
        unsortedRootVegetablesOnlyList.append(Vegetables.init(name: "Daikon",       startSeason: 1, endSeason: 4)!)
        unsortedRootVegetablesOnlyList.append(Vegetables.init(name: "Ginger",       startSeason: 1, endSeason: 4)!)
        unsortedRootVegetablesOnlyList.append(Vegetables.init(name: "Parsnip",      startSeason: 1, endSeason: 4)!)
        unsortedRootVegetablesOnlyList.append(Vegetables.init(name: "Rutabaga",     startSeason: 1, endSeason: 4)!)
        unsortedRootVegetablesOnlyList.append(Vegetables.init(name: "Turnip",       startSeason: 1, endSeason: 4)!)
        
        // -------------- Radishes --------------
        unsortedRadishesOnlyList.append(Vegetables.init(name: "Rutabaga",           startSeason: 1, endSeason: 12)!)
        unsortedRadishesOnlyList.append(Vegetables.init(name: "Turnip",             startSeason: 1, endSeason: 12)!)
        unsortedRadishesOnlyList.append(Vegetables.init(name: "Wasabi",             startSeason: 1, endSeason: 12)!)
        unsortedRadishesOnlyList.append(Vegetables.init(name: "Horseradish",        startSeason: 1, endSeason: 12)!)
        unsortedRadishesOnlyList.append(Vegetables.init(name: "White radish",       startSeason: 1, endSeason: 12)!)
        
        // -------------- Suqashes --------------
        unsortedSquashesOnlyList.append(Vegetables.init(name: "Acorn squash",       startSeason: 1, endSeason: 12)!)
        unsortedSquashesOnlyList.append(Vegetables.init(name: "Butternut squash",   startSeason: 1, endSeason: 4)!)
        unsortedSquashesOnlyList.append(Vegetables.init(name: "Banana squash",      startSeason: 1, endSeason: 4)!)
        unsortedSquashesOnlyList.append(Vegetables.init(name: "Zucchini",           startSeason: 1, endSeason: 4)!)
        unsortedSquashesOnlyList.append(Vegetables.init(name: "Cucumber",           startSeason: 1, endSeason: 4)!)
        unsortedSquashesOnlyList.append(Vegetables.init(name: "Delicata",           startSeason: 1, endSeason: 4)!)
        unsortedSquashesOnlyList.append(Vegetables.init(name: "Gem squash",         startSeason: 1, endSeason: 4)!)
        unsortedSquashesOnlyList.append(Vegetables.init(name: "Hubbard squash",     startSeason: 1, endSeason: 4)!)
        unsortedSquashesOnlyList.append(Vegetables.init(name: "Squash",             startSeason: 1, endSeason: 4)!)
        unsortedSquashesOnlyList.append(Vegetables.init(name: "Patty pans",         startSeason: 1, endSeason: 4)!)
        unsortedSquashesOnlyList.append(Vegetables.init(name: "Pumpkin",            startSeason: 1, endSeason: 4)!)
        unsortedSquashesOnlyList.append(Vegetables.init(name: "Spaghetti squash",   startSeason: 1, endSeason: 4)!)
        
        // -------------- Tubers --------------
        unsortedTubersOnlyList.append(Vegetables.init(name: "Jicama",               startSeason: 1, endSeason: 12)!)
        unsortedTubersOnlyList.append(Vegetables.init(name: "Jerusalem artichoke",  startSeason: 1, endSeason: 4)!)
        unsortedTubersOnlyList.append(Vegetables.init(name: "Potato",               startSeason: 1, endSeason: 4)!)
        unsortedTubersOnlyList.append(Vegetables.init(name: "Sunchokes",            startSeason: 1, endSeason: 4)!)
        unsortedTubersOnlyList.append(Vegetables.init(name: "Sweet potato",         startSeason: 1, endSeason: 12)!)
        unsortedTubersOnlyList.append(Vegetables.init(name: "Taro",                 startSeason: 1, endSeason: 4)!)
        unsortedTubersOnlyList.append(Vegetables.init(name: "Yam",                  startSeason: 1, endSeason: 4)!)
        
        // -------------- Sorting by season --------------
        vegetablesOnlyList = getSeasonalVegetables(unsortedVegetablesOnlyList)
        legumesOnlyList = getSeasonalVegetables(unsortedLegumesOnlyList)
        herbsSpiciesOnlyList = getSeasonalVegetables(unsortedHerbsSpiciesOnlyList)
        onionsOnlyList = getSeasonalVegetables(unsortedOnionsOnlyList)
        peppersOnlyList = getSeasonalVegetables(unsortedPeppersOnlyList)
        rootVegetablesOnlyList = getSeasonalVegetables(unsortedRootVegetablesOnlyList)
        radishesOnlyList = getSeasonalVegetables(unsortedRadishesOnlyList)
        squashesOnlyList = getSeasonalVegetables(unsortedSquashesOnlyList)
        tubersOnlyList = getSeasonalVegetables(unsortedTubersOnlyList)
        
        
        // -------------- Get the whole list of seasonal vegetables --------------
        anyVegetablesList.append(contentsOf: vegetablesOnlyList)
        anyVegetablesList.append(contentsOf: legumesOnlyList)
        anyVegetablesList.append(contentsOf: herbsSpiciesOnlyList)
        anyVegetablesList.append(contentsOf: onionsOnlyList)
        anyVegetablesList.append(contentsOf: peppersOnlyList)
        anyVegetablesList.append(contentsOf: rootVegetablesOnlyList)
        anyVegetablesList.append(contentsOf: radishesOnlyList)
        anyVegetablesList.append(contentsOf: squashesOnlyList)
        anyVegetablesList.append(contentsOf: tubersOnlyList)
        
        
        var dic = ["Vegetables": vegetablesOnlyList,
                   "Legumes": legumesOnlyList,
                   "Herbs and spices": herbsSpiciesOnlyList,
                   "Onion family": onionsOnlyList,
                   "Peppers": peppersOnlyList,
                   "Root vegetables": rootVegetablesOnlyList,
                   "Radishes": radishesOnlyList,
                   "Squashes": squashesOnlyList,
                   "Tubers" : tubersOnlyList]
        
        if(vegetablesOnlyList.isEmpty){
            dic.removeValue(forKey: "Vegetables")
        }
        if(legumesOnlyList.isEmpty){
            dic.removeValue(forKey: "Legumes")
        }
        if(herbsSpiciesOnlyList.isEmpty){
            dic.removeValue(forKey: "Herbs and spices")
        }
        if(onionsOnlyList.isEmpty){
            dic.removeValue(forKey: "Onion family")
        }
        if(peppersOnlyList.isEmpty){
            dic.removeValue(forKey: "Peppers")
        }
        if(rootVegetablesOnlyList.isEmpty){
            dic.removeValue(forKey: "Root vegetables")
        }
        if(radishesOnlyList.isEmpty){
            dic.removeValue(forKey: "Radishes")
        }
        if(squashesOnlyList.isEmpty){
            dic.removeValue(forKey: "Squashes")
        }
        if(tubersOnlyList.isEmpty){
            dic.removeValue(forKey: "Tubers")
        }

        return dic
    }
}


