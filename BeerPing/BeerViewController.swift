//
//  BeerViewController.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 19/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit

class BeerViewController: UIViewController {
    
    @IBOutlet weak var beerName: UILabel!
    @IBOutlet weak var brewery: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var beerDescription: UILabel!
    @IBOutlet weak var abv: UILabel!
    @IBOutlet weak var ibu: UILabel!
    
    var beerLabelText = "Voeh"
    var beerList:Array <Beer> = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let filteredBeers = beerList.filter( { return $0.name == beerLabelText } )
        
        print(filteredBeers[0])
        
        beerName.text = filteredBeers[0].name
        brewery.text = brewery.text! + filteredBeers[0].brewer!
        type.text = filteredBeers[0].type
        beerDescription.text = beerDescription.text! + "\n" + filteredBeers[0].desc!
        abv.text = String(filteredBeers[0].abv)
        ibu.text = String(filteredBeers[0].ibu)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
