//
//  BarTableViewController.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 11/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit
import CoreData

class BarTableViewController: UITableViewController {
    
    var fetchedResultsController = NSFetchedResultsController<Bar>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest<Bar>(entityName: "Bar")
        
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true) ]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DatabaseController.getContext(), sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        }catch {
            print("fetchedResultsController.performFetch() failed")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return (fetchedResultsController.sections?.count)!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        return sections [ section ].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "BarTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BarTableViewCell else {
            fatalError("The dequeued cell is not an instance of BarTableViewCell.")
        }
    
        cell.barName?.text = (fetchedResultsController.object(at: indexPath)).name

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBeers" {
            
            let cell = sender as! BarTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let destViewController: BeerTableViewController = segue.destination as! BeerTableViewController
            
            destViewController.barName = fetchedResultsController.object(at: indexPath!).name!
            
            destViewController.hidesBottomBarWhenPushed = true
        }
    }
}
