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
    var currentLocation: CLLocation?
    var currentLocation2d: CLLocationCoordinate2D?
    var userLocation: MKUserLocation?
    var locationManager: CLLocationManager!
    
//    lazy var locationManager: CLLocationManager = {
//        let manager = CLLocationManager()
//        manager.delegate = self
//        //manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        return manager
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        mapView.showsUserLocation = true
        annotations()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineMyCurrentLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        print("Success")
//    }
//    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        print("Fail")
//    }
    
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        
//        //Center the user location on map view
//        mapView.centerCoordinate = userLocation.location!.coordinate
//        
//        let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 1000, 1000)
//        
//        mapView.setRegion(region, animated: false)
//        
//    }
    
    
    //Adding annotations to some bars/pubs
    func annotations() {
        
        let williamK = Annotation(title: "William K, Sello", coordinate: CLLocationCoordinate2D(latitude: 60.2181479, longitude: 24.8070826), subtitle: "Leppävaara, Espoo")
        
        mapView.addAnnotation(williamK)
        
    }
}




