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
    @IBOutlet weak var imageView: UIImageView!
    var imageURL: String = ""
    var beerLabelText = "Voeh"
    var beerList:Array <Beer> = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let filteredBeers = beerList.filter( { return $0.name == beerLabelText } )
        imageURL = "http://users.metropolia.fi/~ottoja/beerbluds/images/" + filteredBeers[0].image!
        
        getImage(imageURL, imageView)
        
        print(filteredBeers[0])
        
        beerName.text = filteredBeers[0].name
        brewery.text = brewery.text! + filteredBeers[0].brewer!
        type.text = filteredBeers[0].type
        beerDescription.text = beerDescription.text! + "\n" + filteredBeers[0].desc!
        abv.text = abv.text! + String(filteredBeers[0].abv)
        ibu.text = ibu.text! + String(filteredBeers[0].ibu)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImage (_  url_str: String, _ imageView: UIImageView) {
        
        let url: URL = URL(string: url_str)!
        let session = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response ,error) in
            
            if data != nil {
                let image = UIImage(data: data!)
                
                if(image != nil) {
                    DispatchQueue.main.async(execute: {
                        
                        imageView.image = image
                        imageView.alpha = 0
                        
                        UIView.animate(withDuration: 2.5, animations: {
                            imageView.alpha = 1.0
                        })
                    })
                }
            }
        })
        task.resume()
    }
}
