//
//  BeerViewController.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 19/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class BeerViewController: UIViewController {
    
    @IBOutlet weak var beerName: UILabel!
    @IBOutlet weak var brewery: UILabel!
    @IBOutlet weak var style: UILabel!
    @IBOutlet weak var abv: UILabel!
    @IBOutlet weak var ibu: UILabel!
    @IBOutlet weak var beerDescription: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var beerLabelText = "Voeh"
    var beerList:Array <Beer> = []
    
    override func viewDidLoad() {
        
        
        let storage = FIRStorage.storage()
        
        let barRef = storage.reference().child("beers")
        let flagRef = storage.reference().child("flags")
        
        super.viewDidLoad()
        
        let filteredBeers = beerList.filter( { return $0.name == beerLabelText } )
        
        let imageURL = barRef.child("\(filteredBeers[0].image!)")
        let flagURL = flagRef.child("\(filteredBeers[0].country!)")
        
        getImage(imageURL: imageURL, imageView: imageView)
        getImage(imageURL: flagURL, imageView: flagImage)
        
        beerName.text = filteredBeers[0].name
        brewery.text = filteredBeers[0].brewer!
        style.text = filteredBeers[0].style
        beerDescription.text = filteredBeers[0].desc!
        abv.text = String(filteredBeers[0].abv) + "%"
        ibu.text = String(filteredBeers[0].ibu)
        price.text = String(describing: filteredBeers[0].price!) + "/" + filteredBeers[0].volume!
    }
    
    func getImage (imageURL: FIRStorageReference, imageView: UIImageView) {
        
        imageURL.data(withMaxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
            } else {
                if data != nil {
                    let image = UIImage(data: data!)
                    
                    if(image != nil) {
                        DispatchQueue.main.async(execute: {
                            
                            imageView.image = image
                            imageView.alpha = 0
                             
                             UIView.animate(withDuration: 1.5, animations: {
                                imageView.alpha = 1.0
                             })
                            
                        })
                        
                    }
                }
            }
        }
    }
}
