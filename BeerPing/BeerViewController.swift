//
//  BeerViewController.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 19/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit

class BeerViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var beerName: UILabel!
    @IBOutlet weak var brewery: UILabel!
    @IBOutlet weak var style: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var beerDescription: UILabel!
    @IBOutlet weak var abv: UILabel!
    @IBOutlet weak var ibu: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageURL: String = ""
    var flagURL: String = ""
    var beerLabelText = "Voeh"
    var beerList:Array <Beer> = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let filteredBeers = beerList.filter( { return $0.name == beerLabelText } )
        
        imageURL = "http://users.metropolia.fi/~ottoja/beerbluds/images/" + filteredBeers[0].image!
        flagURL = "http://users.metropolia.fi/~ottoja/beerbluds/images/" + filteredBeers[0].country!
                
        getImage(imageURL, imageView)
        getImage(flagURL, flagImage)
        
        beerName.text = filteredBeers[0].name
        brewery.text = filteredBeers[0].brewer!
        style.text = filteredBeers[0].style
        beerDescription.text = filteredBeers[0].desc!
        abv.text = String(filteredBeers[0].abv) + "%"
        ibu.text = String(filteredBeers[0].ibu)
        price.text = String(describing: filteredBeers[0].price!) + "/" + filteredBeers[0].volume!
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
