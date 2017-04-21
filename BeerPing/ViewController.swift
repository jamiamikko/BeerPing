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
        
        //Configure location manager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 10.0
        
        getFirstLocation()

        
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        annotations()
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
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "Annotation"
        
        if annotation is Annotation {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                annotationView.annotation = annotation
                annotationView.image = UIImage(named: "cap-filled")
                return annotationView
            } else {
                let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView.isEnabled = true
                annotationView.canShowCallout = true
                
                let btn = UIButton(type: .detailDisclosure)
                annotationView.rightCalloutAccessoryView = btn
                
                
                return annotationView
            }
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation = view.annotation as? Annotation
        
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "fromMapToBeers", sender: annotation?.title)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromMapToBeers" {
            let destViewController: BeerTableViewController = segue.destination as! BeerTableViewController
            
            destViewController.barName = String(describing: sender!)
            print(sender!)
            

            print(sender ?? "voej")

        }
    }

}




