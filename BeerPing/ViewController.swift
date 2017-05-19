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
import Firebase

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var searchForBars: UISwitch!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager:CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var barAnnotationView: MKAnnotationView!
    var fetchedResultsController = NSFetchedResultsController<Bar>()
    
    let region1 = CLBeaconRegion.init(proximityUUID: NSUUID(uuidString: "824EDFBF-874E-4D14-A8B6-065D8730E867")! as UUID, identifier: "William K, Sello")
    
    let rootRef = FIRDatabase.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view, typically from a nib.
        
        let barRef = rootRef.child("bars")
        
        barRef.observe(.value, with: { (snapshot: FIRDataSnapshot) in
            print(snapshot)
        })
        
        locationManager.delegate = self
        
        region1.notifyOnEntry = true
        region1.notifyOnExit = true
        
        let status = CLLocationManager.authorizationStatus()
        
        //Check the user's authorization status
        if status == CLAuthorizationStatus.notDetermined {
            locationManager.requestAlwaysAuthorization()
        }else {
            getFirstLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = 10.0
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted, error in
        })
        
        UNUserNotificationCenter.current().delegate = self
        
        //getFirstLocation()
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

    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        let currentRegion = region as! CLBeaconRegion
        
        print("Started monitoring for \(currentRegion.proximityUUID)")
        
        //createNotification(region: region)
    }
    
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Error: \(error)")
        searchForBars.setOn(false, animated: true)
        locationManager.stopMonitoring(for: region1)
        print("Stopping monitoring")
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        print("enter region " + region.identifier)
        
        createNotification(region: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit region " + region.identifier)
        searchForBars.setOn(false, animated: true)
        locationManager.stopMonitoring(for: region1)
        print("Stopping monitoring")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        if startLocation == nil {
            startLocation = latestLocation            
        }
        
        if searchForBars.isOn {
            locationManager.startMonitoring(for: region1)
        }
        
    }
    
    //This function zooms and centers the user location when map is loaded. Gets called on ViewDidLoad()
    func getFirstLocation () {
        
        startLocation = locationManager.location
        
        let currentLocation2d = startLocation.coordinate

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
    
    
    func createNotification(region: CLRegion) {
        
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
        
        searchForBars.setOn(false, animated: true)
        locationManager.stopMonitoring(for: region1)
        print("Stopping monitoring")
    }
    
    //Toggle action for switch in top right corner of map view.
    @IBAction func searchForBeaconsValueChange(_ sender: Any) {
        
        if searchForBars.isOn {
            locationManager.startMonitoring(for: region1)
        } else {
            locationManager.stopMonitoring(for: region1)
            print("Stopping monitoring")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            print("authorization status not determined")
        } else if (status == CLAuthorizationStatus.authorizedAlways) {
            // The user accepted authorization
            getFirstLocation()
        } 
    }
}




