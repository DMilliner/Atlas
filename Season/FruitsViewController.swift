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
    
    var detailViewController: FruitDetailViewController? = nil
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
        
        //Necessary for first run coming from Detail
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        dictionary = getSortedFruitsList()
        for (key, value) in dictionary {
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? FruitDetailViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFruitDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let cell = self.tableView.cellForRow(at: indexPath) {
                    
                    let controller = (segue.destination as! UINavigationController).topViewController as! FruitDetailViewController
                    controller.detailItem = cell.textLabel?.text
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            }
        }
    }
    
    // MARK: - Table View
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }
    
    // create a cell for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row].name
        cell.textLabel?.textColor = UIColor.darkGray
        
//        if(objectArray[indexPath.section].sectionName == "Berries"){
//            cell.FruitCellImage.backgroundColor = UIColor.init(red: 30/255.0, green: 90/255.0, blue: 225/255.0, alpha: 1.0)
//        } else {
//            cell.FruitCellImage.backgroundColor = UIColor.init(red: 245/255.0, green: 90/255.0, blue: 65/255.0, alpha: 1.0)
//        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        UserDefaults.standard.set(indexPath.section, forKey: "fruitIndexPathSection")
        UserDefaults.standard.set(indexPath.row, forKey: "fruitIndexPathRow")
        UserDefaults.standard.synchronize()
        print("F -Saved")
        
        performSegue(withIdentifier: "showFruitDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectArray[section].sectionName
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    func getSortedFruitsList() -> [String:[Fruits]]{
        seasonalFruitsList.removeAll()
        
        pomeFruitsOnlyList.removeAll()
        stoneFruitsOnlyList.removeAll()
        temperateFruitsOnlyList.removeAll()
        berriesOnlyList.removeAll()
        mediterraneanNativesOnlyList.removeAll()
        citrusOnlyList.removeAll()
        subtropicalfruitsOnlyList.removeAll()
        tropicalFruitsOnlyList.removeAll()
        
        var unsortedPomeFruitsOnlyList: [Fruits] = []
        var unsortedStoneFruitsOnlyList: [Fruits] = []
        var unsortedTemperateFruitsOnlyList: [Fruits] = []
        var unsortedBerriesOnlyList: [Fruits] = []
        var unsortedMediterraneanNativesOnlyList: [Fruits] = []
        var unsortedCitrusOnlyList: [Fruits] = []
        var unsortedSubtropicalfruitsOnlyList: [Fruits] = []
        var unsortedTropicalFruitsOnlyList: [Fruits] = []
        
        
        //14 doubles.... 
        
        // -------------- Pome fruits --------------
        unsortedPomeFruitsOnlyList.append(Fruits.init(name: "Apple",        startSeason: 1, endSeason: 11)!)
        unsortedPomeFruitsOnlyList.append(Fruits.init(name: "Chokeberry",          startSeason: 11, endSeason: 12)!)
        unsortedPomeFruitsOnlyList.append(Fruits.init(name: "Hawthorn",        startSeason: 1, endSeason: 11)!)
        unsortedPomeFruitsOnlyList.append(Fruits.init(name: "Loquat",         startSeason: 1, endSeason: 4)!)  /////
        unsortedPomeFruitsOnlyList.append(Fruits.init(name: "Medlar",         startSeason: 1, endSeason: 4)!) /////
        unsortedPomeFruitsOnlyList.append(Fruits.init(name: "Pear",     startSeason: 1, endSeason: 4)!)
        unsortedPomeFruitsOnlyList.append(Fruits.init(name: "Quince",         startSeason: 1, endSeason: 4)!)
        unsortedPomeFruitsOnlyList.append(Fruits.init(name: "Rose hip", startSeason: 1, endSeason: 4)!)
        unsortedPomeFruitsOnlyList.append(Fruits.init(name: "Rowan",          startSeason: 1, endSeason: 4)!)
        unsortedPomeFruitsOnlyList.append(Fruits.init(name: "Service tree",        startSeason: 1, endSeason: 4)!)
        unsortedPomeFruitsOnlyList.append(Fruits.init(name: "Serviceberry",          startSeason: 1, endSeason: 4)!)
        unsortedPomeFruitsOnlyList.append(Fruits.init(name: "Shipova",      startSeason: 1, endSeason: 4)!)
        
        // -------------- Stone fruits --------------
        unsortedStoneFruitsOnlyList.append(Fruits.init(name: "Apricot",     startSeason: 1, endSeason: 12)!)
        unsortedStoneFruitsOnlyList.append(Fruits.init(name: "Cherry",         startSeason: 1, endSeason: 12)!)
        unsortedStoneFruitsOnlyList.append(Fruits.init(name: "Chokecherry",        startSeason: 1, endSeason: 4)!)
        unsortedStoneFruitsOnlyList.append(Fruits.init(name: "Greengage",         startSeason: 1, endSeason: 4)!)
        unsortedStoneFruitsOnlyList.append(Fruits.init(name: "Peach",     startSeason: 1, endSeason: 4)!)
        unsortedStoneFruitsOnlyList.append(Fruits.init(name: "Plum",       startSeason: 1, endSeason: 4)!)
        
        // -------------- Other temperate fruits --------------
        unsortedTemperateFruitsOnlyList.append(Fruits.init(name: "Boquila",         startSeason: 1, endSeason: 12)!)
        unsortedTemperateFruitsOnlyList.append(Fruits.init(name: "Elaeocarpaceae",         startSeason: 1, endSeason: 12)!)
        unsortedTemperateFruitsOnlyList.append(Fruits.init(name: "Goumi",       startSeason: 1, endSeason: 4)!)
        unsortedTemperateFruitsOnlyList.append(Fruits.init(name: "Honeyberry",      startSeason: 1, endSeason: 4)!)
        unsortedTemperateFruitsOnlyList.append(Fruits.init(name: "Keule",     startSeason: 1, endSeason: 4)!)
        unsortedTemperateFruitsOnlyList.append(Fruits.init(name: "Lardizabala",          startSeason: 1, endSeason: 4)!)
        unsortedTemperateFruitsOnlyList.append(Fruits.init(name: "Maqui",        startSeason: 1, endSeason: 4)!)
        unsortedTemperateFruitsOnlyList.append(Fruits.init(name: "Pawpaw",      startSeason: 1, endSeason: 4)!)
        unsortedTemperateFruitsOnlyList.append(Fruits.init(name: "Peumo",   startSeason: 1, endSeason: 4)!)
        unsortedTemperateFruitsOnlyList.append(Fruits.init(name: "Fox grape",      startSeason: 1, endSeason: 4)!)
        unsortedTemperateFruitsOnlyList.append(Fruits.init(name: "Riverbank grape",       startSeason: 1, endSeason: 4)!)
        unsortedTemperateFruitsOnlyList.append(Fruits.init(name: "Sand grape",       startSeason: 1, endSeason: 4)!)
        unsortedTemperateFruitsOnlyList.append(Fruits.init(name: "Amur grape",      startSeason: 1, endSeason: 4)!)
        
        // -------------- Berries --------------
        unsortedBerriesOnlyList.append(Fruits.init(name: "Raspberries",              startSeason: 1, endSeason: 12)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Blackberry",              startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Cloudberry",  startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Loganberry",               startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Raspberry species",             startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Salmonberry",         startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Thimbleberry",              startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Wineberry",  startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Bearberry",              startSeason: 1, endSeason: 12)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Bilberry",              startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Blueberry",  startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Crowberry",               startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Cranberry",             startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Falberry",         startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Huckleberry",              startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Lingonberry",  startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Currant",              startSeason: 1, endSeason: 12)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Elderberry",              startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Gooseberry",  startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Hackberry",               startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Honeysuckle",             startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Mulberry",         startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Mayapple",              startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Nannyberry",  startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Oregon grape",              startSeason: 1, endSeason: 12)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Sea buckthorn",              startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Strawberry",  startSeason: 1, endSeason: 4)!)
        unsortedBerriesOnlyList.append(Fruits.init(name: "Ugni",               startSeason: 1, endSeason: 4)!) /////
        unsortedBerriesOnlyList.append(Fruits.init(name: "Wolfberry",             startSeason: 1, endSeason: 4)!)
        
        // -------------- Mediterranean natives --------------
        unsortedMediterraneanNativesOnlyList.append(Fruits.init(name: "Grapes",         startSeason: 1, endSeason: 12)!)
        unsortedMediterraneanNativesOnlyList.append(Fruits.init(name: "Olives",        startSeason: 1, endSeason: 4)!)
        unsortedMediterraneanNativesOnlyList.append(Fruits.init(name: "Black mulberry",            startSeason: 1, endSeason: 4)!) /////
        unsortedMediterraneanNativesOnlyList.append(Fruits.init(name: "Cornelian cherry",            startSeason: 1, endSeason: 4)!)
        unsortedMediterraneanNativesOnlyList.append(Fruits.init(name: "Date",             startSeason: 1, endSeason: 4)!)
        unsortedMediterraneanNativesOnlyList.append(Fruits.init(name: "Fig",      startSeason: 1, endSeason: 4)!)
        unsortedMediterraneanNativesOnlyList.append(Fruits.init(name: "Jujube",      startSeason: 1, endSeason: 4)!)
        unsortedMediterraneanNativesOnlyList.append(Fruits.init(name: "Pomegranate",      startSeason: 1, endSeason: 4)!) /////
        unsortedMediterraneanNativesOnlyList.append(Fruits.init(name: "Sycamore fig",      startSeason: 1, endSeason: 4)!)
        
        // -------------- Citrus --------------
        unsortedCitrusOnlyList.append(Fruits.init(name: "Lemon",         startSeason: 1, endSeason: 12)!)
        unsortedCitrusOnlyList.append(Fruits.init(name: "Blood orange",       startSeason: 1, endSeason: 4)!)
        unsortedCitrusOnlyList.append(Fruits.init(name: "Clementine",     startSeason: 1, endSeason: 4)!)
        unsortedCitrusOnlyList.append(Fruits.init(name: "Grapefruit",       startSeason: 1, endSeason: 4)!) /////
        unsortedCitrusOnlyList.append(Fruits.init(name: "Kumquat",       startSeason: 1, endSeason: 4)!)
        unsortedCitrusOnlyList.append(Fruits.init(name: "Lime",      startSeason: 1, endSeason: 4)!) /////
        unsortedCitrusOnlyList.append(Fruits.init(name: "Mandarin",     startSeason: 1, endSeason: 4)!)
        unsortedCitrusOnlyList.append(Fruits.init(name: "Naartjie",       startSeason: 1, endSeason: 4)!)
        unsortedCitrusOnlyList.append(Fruits.init(name: "Orange",         startSeason: 1, endSeason: 12)!) /////
        unsortedCitrusOnlyList.append(Fruits.init(name: "Pomelo",       startSeason: 1, endSeason: 4)!)
        unsortedCitrusOnlyList.append(Fruits.init(name: "Sweet lemon",     startSeason: 1, endSeason: 4)!)
        unsortedCitrusOnlyList.append(Fruits.init(name: "Kabosu",       startSeason: 1, endSeason: 4)!)
        unsortedCitrusOnlyList.append(Fruits.init(name: "Oroblanco",       startSeason: 1, endSeason: 4)!)
        unsortedCitrusOnlyList.append(Fruits.init(name: "Tangerine",      startSeason: 1, endSeason: 4)!) /////
        
        // -------------- Other subtropical fruits --------------
        unsortedSubtropicalfruitsOnlyList.append(Fruits.init(name: "Avocado",           startSeason: 1, endSeason: 12)!)
        unsortedSubtropicalfruitsOnlyList.append(Fruits.init(name: "Carob",       startSeason: 1, endSeason: 4)!)
        unsortedSubtropicalfruitsOnlyList.append(Fruits.init(name: "Feijoa",       startSeason: 1, endSeason: 4)!)
        unsortedSubtropicalfruitsOnlyList.append(Fruits.init(name: "Guava",  startSeason: 1, endSeason: 4)!) /////
        unsortedSubtropicalfruitsOnlyList.append(Fruits.init(name: "Longan", startSeason: 1, endSeason: 4)!) /////
        unsortedSubtropicalfruitsOnlyList.append(Fruits.init(name: "Lúcuma",           startSeason: 1, endSeason: 12)!)
        unsortedSubtropicalfruitsOnlyList.append(Fruits.init(name: "Lychee",       startSeason: 1, endSeason: 4)!) /////
        unsortedSubtropicalfruitsOnlyList.append(Fruits.init(name: "Passion fruit",       startSeason: 1, endSeason: 4)!) /////
        unsortedSubtropicalfruitsOnlyList.append(Fruits.init(name: "Peanut",  startSeason: 1, endSeason: 4)!)
        unsortedSubtropicalfruitsOnlyList.append(Fruits.init(name: "Pond-apple", startSeason: 1, endSeason: 4)!)
        unsortedSubtropicalfruitsOnlyList.append(Fruits.init(name: "Strawberry guava",       startSeason: 1, endSeason: 4)!) //////
        unsortedSubtropicalfruitsOnlyList.append(Fruits.init(name: "Tamarillo",       startSeason: 1, endSeason: 4)!)
        unsortedSubtropicalfruitsOnlyList.append(Fruits.init(name: "Yangmei",  startSeason: 1, endSeason: 4)!)
        unsortedSubtropicalfruitsOnlyList.append(Fruits.init(name: "Néré", startSeason: 1, endSeason: 4)!)
        
        // -------------- Tropical fruits --------------
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Abiu",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Açaí",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Acerola",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Ackee",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "African cherry orange",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "African moringa",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Agave",     startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Allspice",             startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Ambarella",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "American persimmon",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Araza",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Atemoya",            startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Babaco",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Bacupari",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Bacuri",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Bael",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Banana",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Barbadine",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Barbados cherry",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Betel nut",     startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Bignay",             startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Bilimbi",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Biribi",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Black mulberry",   startSeason: 1, endSeason: 4)!) /////
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Black sapote",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Bolivian coconut",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Bottle gourd",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Breadnut",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Burmese grape",           startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Caimito",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Calabash tree",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Calamansi",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Camu camu",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Canistel",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Cape gooseberry",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Capulin cherry",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Carambola",     startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Cassabanana",             startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Cattley guava",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Cawesh",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Ceriman",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Ceylon gooseberry",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Chayote",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Chempedak",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Chenet",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Cherimoya",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Chilean guava",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Chinese jujube",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Cherry of the Rio Grande",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Chinese olive",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Chupa-chupa",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Coco plum",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Cocona",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Double coconut",     startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Coconut",             startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Cola nut",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Costa Rican guava",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Cupuaçu",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Curry-leaf tree",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Cocoplum",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Custard apple",   startSeason: 1, endSeason: 4)!)

        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Damson plum",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Date plum",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Dead man's fingers",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Dragonfruit",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Duku",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Durian",           startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Elephant apple",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Emblica",     startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Gambooge",             startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Genip",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Giant granadilla",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Governor’s plum",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Grapes",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Grapefruit",             startSeason: 1, endSeason: 4)!) /////
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Grumichama",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Guanabana",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Guarana",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Guava",            startSeason: 1, endSeason: 4)!) /////
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Guavaberry",            startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Hairless rambutan",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Hog plum",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Horned melon",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Huito",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Honeydew",           startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Ice cream bean",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Ilama",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Imbe",     startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Indian almond",             startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Indian fig",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Indian gooseberry",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Indian jujube",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Indian prune",            startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Jaboticaba",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Jackfruit",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Jambul",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Jatobá",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Jelly plum",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Jocote",   startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Kandis",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Kapok",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Karonda",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Kei apple",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Kepel fruit",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Key lime",     startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Kitembilla",             startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Kiwano",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Kiwifruit",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Kwai muk",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Korlan",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Kundong",       startSeason: 1, endSeason: 12)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Lakoocha",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Langsat",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Lanzones",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Lemon",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Leucaena",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Limeberry",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Limequat",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Lime",           startSeason: 1, endSeason: 4)!) /////
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Longan",           startSeason: 1, endSeason: 4)!) /////
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Loquat",         startSeason: 1, endSeason: 4)!) /////
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Louvi",     startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Lucuma",             startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Lychee",         startSeason: 1, endSeason: 4)!) /////
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Mabolo",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Macadamia",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Madrono",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Malabar plum",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Malay apple",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Mamey",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Mamoncillo",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Mangaba",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Mango",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Mangosteen",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Manila tamarind",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Ma-praang",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Mayan breadnut",     startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Maypop",             startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Medlar",         startSeason: 1, endSeason: 4)!) /////
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Meiwa kumquat",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Melinjo",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Melon pear",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Miracle fruit",             startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Monstera",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Montessa granadilla",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Mountain soursop",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Monkey jackfruit",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Monkey tamarind",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Mundu",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Muskmelon",            startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Nagami kumquat",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Nance",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Naranjilla",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Neem",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Noni",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Nutmeg",         startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Oil palm",     startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Olive",             startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Otaheite gooseberry",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Orange",            startSeason: 1, endSeason: 4)!) /////
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Oriental persimmon",   startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Palmyra palm",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Papaya",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Passion fruit",      startSeason: 1, endSeason: 4)!) /////
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Peach palm",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Peanut butter fruit",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pecan",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pepino",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pequi",     startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pewa",             startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Phalsa",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pigeon pea",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pili nut",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pindo palm",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pineapple",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pineapple guava",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pistachio",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pitaya",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pitomba",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pois doux",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pomegranate",      startSeason: 1, endSeason: 4)!) /////
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pommecythère",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pommerac",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pulasan",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pummelo",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Pupunha",     startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Purple guava",             startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Purple granadilla",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Purple mombin",            startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Rambutan",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Red granadilla",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Red mombin",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Riberry",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Ridged gourd",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Rollinia",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Rose apple",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Rough shell macadamia",   startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Safou",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Salak",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Santol",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Sapodilla",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Sea grape",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Soncoya",     startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Soursop",             startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Spanish lime",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Star apple",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Strawberry guava",   startSeason: 1, endSeason: 4)!) /////
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Strawberry pear",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Sugar apple",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Summer squash",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Damson plum",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Surinam cherry",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Sweet granadilla",      startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Sweet orange",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Sweet pepper",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Sweetsop",           startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Tahitian apple",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Tangerine",     startSeason: 1, endSeason: 4)!) //////
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Tamarind",             startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Tomato",         startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Ugni",            startSeason: 1, endSeason: 4)!) /////
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Vanilla",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Velvet tamarind",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Voavanga",             startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Wampee",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Water apple",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Watermelon",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Wax jambu",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Wax gourd",            startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "White sapote",       startSeason: 1, endSeason: 12)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Winged bean",   startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Wood apple",      startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Xigua",           startSeason: 1, endSeason: 4)!)
        
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Yantok",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Yellow granadilla",           startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Yellow mombin",         startSeason: 1, endSeason: 4)!)
        unsortedTropicalFruitsOnlyList.append(Fruits.init(name: "Youngberry",     startSeason: 1, endSeason: 4)!)
        
        // -------------- Sorting by season --------------
        pomeFruitsOnlyList = getSeasonalFruits(unsortedPomeFruitsOnlyList)
        stoneFruitsOnlyList = getSeasonalFruits(unsortedStoneFruitsOnlyList)
        temperateFruitsOnlyList = getSeasonalFruits(unsortedTemperateFruitsOnlyList)
        berriesOnlyList = getSeasonalFruits(unsortedBerriesOnlyList)
        mediterraneanNativesOnlyList = getSeasonalFruits(unsortedMediterraneanNativesOnlyList)
        citrusOnlyList = getSeasonalFruits(unsortedCitrusOnlyList)
        subtropicalfruitsOnlyList = getSeasonalFruits(unsortedSubtropicalfruitsOnlyList)
        tropicalFruitsOnlyList = getSeasonalFruits(unsortedTropicalFruitsOnlyList)
        
        
        // -------------- Get the whole list of seasonal vegetables --------------
        seasonalFruitsList.append(contentsOf: pomeFruitsOnlyList)
        seasonalFruitsList.append(contentsOf: stoneFruitsOnlyList)
        seasonalFruitsList.append(contentsOf: temperateFruitsOnlyList)
        seasonalFruitsList.append(contentsOf: berriesOnlyList)
        seasonalFruitsList.append(contentsOf: mediterraneanNativesOnlyList)
        seasonalFruitsList.append(contentsOf: citrusOnlyList)
        seasonalFruitsList.append(contentsOf: subtropicalfruitsOnlyList)
        seasonalFruitsList.append(contentsOf: tropicalFruitsOnlyList)
        
        let dic = ["Pome fruits": pomeFruitsOnlyList,
                   "Stone fruits": stoneFruitsOnlyList,
                   "Other temperate fruits": temperateFruitsOnlyList,
                   "Berries": berriesOnlyList,
                   "Mediterranean natives": mediterraneanNativesOnlyList,
                   "Citrus": citrusOnlyList,
                   "Other subtropical fruits": subtropicalfruitsOnlyList,
                   "Tropical fruits": tropicalFruitsOnlyList]
        
        return dic
    }
}
