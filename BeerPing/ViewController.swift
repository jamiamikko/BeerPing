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
import UserNotifications

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager:CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    @IBOutlet weak var searchBar: UISearchBar!
    var barAnnotationView: MKAnnotationView!
    var fetchedResultsController = NSFetchedResultsController<Bar>()
    
    let region1 = CLBeaconRegion.init(proximityUUID: NSUUID(uuidString: "824EDFBF-874E-4D14-A8B6-065D8730E867")! as UUID, identifier: "William K, Sello")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        //Configure location manager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 10.0
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted, error in
            
        })
        
        UNUserNotificationCenter.current().delegate = self

        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let notificationBarName = response.notification.request.content.categoryIdentifier
        
        performSegue(withIdentifier: "fromMapToBeers", sender: notificationBarName)
    }

    
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        annotations()
        getFirstLocation()
        
        print("authorization status: " + CLLocationManager.authorizationStatus().rawValue.description)
        
        locationManager.startMonitoring(for: region1)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        let currentRegion = region as! CLBeaconRegion
        
        print("Started monitoring for \(currentRegion.proximityUUID)")
        
        let fetchRequest = NSFetchRequest<Bar>(entityName: "Bar")
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", currentRegion.proximityUUID as CVarArg)
        
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "uuid", ascending: true) ]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DatabaseController.getContext(), sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            
        }catch {
            print("fetchedResultsController.performFetch() failed")
        }
        
        let content = UNMutableNotificationContent()
        
        content.title = "Found a beacon"
        content.subtitle = ""
        content.body = "Entered region of \(currentRegion.identifier)"
        content.badge = 1
        content.categoryIdentifier = (fetchedResultsController.fetchedObjects?[0].name!)!
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false )
        
        let requestIdentifier = "Voeh"
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger:trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("enter region " + region.identifier)
        
        let currentRegion = region as! CLBeaconRegion
        
        let fetchRequest = NSFetchRequest<Bar>(entityName: "Bar")
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", currentRegion.proximityUUID as CVarArg)
        
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "uuid", ascending: true) ]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DatabaseController.getContext(), sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            
        }catch {
            print("fetchedResultsController.performFetch() failed")
        }
        
        let content = UNMutableNotificationContent()
        
        content.title = "Found a beacon"
        content.subtitle = ""
        content.body = "Entered region of \(currentRegion.identifier)"
        content.badge = 1
        content.categoryIdentifier = (fetchedResultsController.fetchedObjects?[0].name!)!
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false )
        
        let requestIdentifier = "Voeh"
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger:trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit region " + region.identifier)
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

    
    func getFirstLocation () {
        
        startLocation = locationManager.location
        
        let currentLocation2d = startLocation.coordinate
        
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
        
        if annotation is MKUserLocation {
            return nil
        }

        let reuseId = "pin"

        self.barAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)

        if self.barAnnotationView == nil {
            self.barAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            self.barAnnotationView!.image = UIImage(named: "bar-pointer.png")
            self.barAnnotationView!.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            self.barAnnotationView?.rightCalloutAccessoryView = btn
        }
        else {
            self.barAnnotationView!.annotation = annotation
        }
        return self.barAnnotationView
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

        }
    }

    @IBAction func backToUser(_ sender: UIButton) {

        getFirstLocation()
    }
    
    
    
//    func calculateDistance () {
//        if let userLocation = mapView.userLocation.location, let annotation = self.barAnnotationView.annotation {
//            // Calculate the distance from the user to the annotation
//            let annotationLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
//            let distanceFromUserToAnnotationInMeters = userLocation.distance(from: annotationLocation)
//            print(distanceFromUserToAnnotationInMeters)
//        }
//    }
}




