//
//  DropablePin.swift
//  pixel-city
//
//  Created by Donald Belliveau on 2017-12-15.
//  Copyright © 2017 Donald Belliveau. All rights reserved.
//

import UIKit
import MapKit

class DropablePin: NSObject, MKAnnotation {
    
    /*
     Instance Variablea
     */
    
    dynamic var coordinate: CLLocationCoordinate2D
    var indentifier: String
    
    /*
     Initializer
     */
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.indentifier = identifier
        super.init()
    } // END init.
    
} // END Class.





// DropablePin:  



















