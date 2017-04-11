//
//  ViewController.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 03/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit
import CoreData
import MapKit


class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var currentLocation: CLLocation?
    var currentLocation2d: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        annotations()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        //Center the user location on map view
        mapView.centerCoordinate = userLocation.location!.coordinate
        
        self.currentLocation2d = userLocation.coordinate
        
        let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
        
        
        let lat: CLLocationDegrees = userLocation.coordinate.latitude
        let lon: CLLocationDegrees = userLocation.coordinate.longitude
        
        self.currentLocation = CLLocation(latitude: lat, longitude: lon)
        
    }
    
    //Adding annotations to some bars/pubs
    func annotations() {
        
        let williamK = Annotation(title: "William K, Sello", coordinate: CLLocationCoordinate2D(latitude: 60.2181479, longitude: 24.8070826))
        
        mapView.addAnnotation(williamK)
        
    }
    
}

