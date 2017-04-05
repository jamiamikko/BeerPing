//
//  ViewController.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 03/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var downloadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onDownload(_ sender: Any) {
        
        print("Clicked on download button")
    }


}

