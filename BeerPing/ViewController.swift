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
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager:CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        mapView.showsUserLocation = true
        annotations()
        
        //Configure location manager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 10.0
        
        getFirstLocation()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        
        print("user latitude = \(latestLocation.coordinate.latitude)")
        print("user longitude = \(latestLocation.coordinate.longitude)")
        
        if startLocation == nil {
            startLocation = latestLocation
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        
    }
    
    func getFirstLocation () {
        
        startLocation = locationManager.location
        
        let currentLocation2d = startLocation.coordinate
        
        let lat: CLLocationDegrees = startLocation.coordinate.latitude
        let lon: CLLocationDegrees = startLocation.coordinate.longitude
        
        print(currentLocation2d)
        let region = MKCoordinateRegionMakeWithDistance(currentLocation2d, 400, 400)
        mapView.setRegion(region, animated: false)
        
        
    }
    
    //Adding annotations to some bars/pubs
    func annotations() {
        
        let williamK = Annotation(title: "William K, Sello", coordinate: CLLocationCoordinate2D(latitude: 60.2181479, longitude: 24.8070826), subtitle: "Leppävaara, Espoo")
        
        mapView.addAnnotation(williamK)
        
    }
}




