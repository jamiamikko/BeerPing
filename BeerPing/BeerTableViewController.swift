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
    
    var barName: String!
    @IBOutlet var beerTable: UITableView!
    var fetchedResultsController = NSFetchedResultsController<Beer>()
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var barTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.barTitle.title = barName
        
        let fetchRequest = NSFetchRequest<Beer>(entityName: "Beer")

        let predicate = NSPredicate(format: "bar.name == %@", argumentArray: [ barName ])
        let typePredicate = NSPredicate(format: "recommended == %@", NSNumber(booleanLiteral: true))
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate, typePredicate])
        
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true) ]
        fetchRequest.predicate = andPredicate
        
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
        
        let cellIdentifier: String = "BeerTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BeerTableViewCell else {
                        fatalError("The dequeued cell is not an instance of BeerTableViewCell.")
        }
        
        cell.beerName?.text = (fetchedResultsController.object(at: indexPath)).name
        
        return cell
    }
    
    func filterBeers() {
        
        if segmentedController.selectedSegmentIndex == 0 {
            
            let predicate = NSPredicate(format: "bar.name == %@", argumentArray: [ barName ])
            let typePredicate = NSPredicate(format: "recommended == %@", NSNumber(booleanLiteral: true))
            let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate, typePredicate])
            
            fetchedResultsController.fetchRequest.predicate = andPredicate
        }
        else if segmentedController.selectedSegmentIndex == 1{
            
            let predicate = NSPredicate(format: "bar.name == %@", argumentArray: [ barName ])
            let typePredicate = NSPredicate(format: "type == %@","On tap")
            let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate, typePredicate])
            
            fetchedResultsController.fetchRequest.predicate = andPredicate
        }
        else if segmentedController.selectedSegmentIndex == 2 {
            
            let predicate = NSPredicate(format: "bar.name == %@", argumentArray: [ barName ])
            let typePredicate = NSPredicate(format: "type == %@","Bottle")
            let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicate, typePredicate])
            
            fetchedResultsController.fetchRequest.predicate = andPredicate
        }
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        filterBeers()
        beerTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBeerDetails" {
            
            let cell = sender as! BeerTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let destViewController: BeerViewController = segue.destination as! BeerViewController
            
            destViewController.beerLabelText = fetchedResultsController.object(at: indexPath!).name!
            
            destViewController.beerList = [fetchedResultsController.object(at: indexPath!)]
        }
    }
}
