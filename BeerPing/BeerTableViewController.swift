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
        
        getBeers()
        
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
    
    func getBeers() {
        let url = URL(string: "http://users.metropolia.fi/~ottoja/beerbluds/williamk.json")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil
            {
                print ("ERROR")
            }
            else{
                if let content = data
                {
                    print(content)
                    do
                    {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any]]
                        
                        for result in myJson {
                            self.beers.append(result["name"] as! String)
                        }
                        
                    }
                    catch{
                        print("error")
                    }
                }
            }
        }
        task.resume()

    }

}
