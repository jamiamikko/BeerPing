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
    
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
}
