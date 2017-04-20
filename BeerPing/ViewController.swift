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
        
        let fetchRequest:NSFetchRequest<Bar> = Bar.fetchRequest()
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            
            for result in searchResults as [Bar] {
                
                let pin = Annotation(title: result.name!, coordinate: CLLocationCoordinate2D(latitude: result.latitude, longitude:
                result.longitude), subtitle: result.location!)
                
                mapView.addAnnotation(pin)
                
            }
        } catch {
            print("Error: \(error)")
        }
        
        
        
    }
}




