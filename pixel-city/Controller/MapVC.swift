//
//  MapVC.swift
//  pixel-city
//
//  Created by Donald Belliveau on 2017-12-15.
//  Copyright © 2017 Donald Belliveau. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {
    
    /*
     IBOutlets
     */
    
    @IBOutlet weak var mapView: MKMapView!
    
    /*
     Instance Variables
     */
    
    var locationManager = CLLocationManager()
    
    
    /*
     Functions
     */
    
    
    // View Did Load Function.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
    } // END View Did Load
    
    
    // Center Button Was Pressed Function.
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        
        
        
    } // END Center Button Was Pressed.
    
    
} // END Class.

extension MapVC: MKMapViewDelegate {
    
}

extension MapVC: CLLocationManagerDelegate {
    
}


// MapVC:  

































