//
//  BeerTableViewController.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 11/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit
import CoreData

class BeerTableViewController: UITableViewController {
    
    var beers:Array<String> = []
    var barName: String = "Voeh"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let fetchRequest:NSFetchRequest<Bar> = Bar.fetchRequest()
        
        let filter = barName
        let predicate = NSPredicate(format: "name = %@", filter)
        fetchRequest.predicate = predicate
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            
            for result in searchResults as [Bar] {
                
                print(result.beers)
            }
        } catch {
            print("Error: \(error)")
        }


        
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
            fatalError("The dequeued cell is not an instance of BeerTableViewCell.")
        }
        
        
        cell.beerName?.text = beers[indexPath.row]
        
        return cell
    }
    

}
