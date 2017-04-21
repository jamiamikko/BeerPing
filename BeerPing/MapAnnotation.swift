//
//  Annotation.swift
//  MapExercise
//
//  Created by iosdev on 5.4.2017.
//  Copyright © 2017 memyself. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Annotation: NSObject, MKAnnotation {
 
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    var pinCustomImage:UIImage!
    
    init(title: String, coordinate: CLLocationCoordinate2D, subtitle: String) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
    }
    
}
