//
//  BeerTableViewController.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 11/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit

class BeerTableViewController: UITableViewController {
    
    var beers:Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        beers = ["Roopen bisse :D", "Mikon bisse :D", "Oton bisse :D"]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "BeerTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BeerTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        
        cell.beerName?.text = beers[indexPath.row]
        
        return cell
    }

}
