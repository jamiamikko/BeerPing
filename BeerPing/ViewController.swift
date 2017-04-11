//
//  ViewController.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 03/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    
    @IBOutlet weak var setNameButton: UIButton!
    
    @IBOutlet weak var usernameTextfield: UITextField!
    
    var numberOfRows: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
        
            for result in searchResults as [User] {
                DatabaseController.getContext().delete(result)
                DatabaseController.saveContext()
            }
            
            if searchResults.count > 0 && (searchResults[0].name != nil) {
                print("Found a user!")
            } else {
                print("Create new user")
            }
            
        } catch {
            print("Error: \(error)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSetUsername(_ sender: Any) {
        if usernameTextfield.text?.isEmpty != nil {
            
            let userClassName:String = String(describing: User.self)
            
            let user: User = NSEntityDescription.insertNewObject(forEntityName: userClassName, into: DatabaseController.getContext()) as! User
            
            user.name = usernameTextfield.text ?? "user"
            
            DatabaseController.saveContext()
            
            performSegue(withIdentifier: "toSecondView", sender: nil)
            
        }
        
    }
    
}

