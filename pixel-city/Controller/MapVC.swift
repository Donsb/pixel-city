//
//  MapVC.swift
//  pixel-city
//
//  Created by Donald Belliveau on 2017-12-15.
//  Copyright © 2017 Donald Belliveau. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    /*
     IBOutlets
     */
    
    @IBOutlet weak var mapView: MKMapView!
    
    /*
     Functions
     */
    
    
    // View Did Load Function.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
        
    } // END View Did Load
    
    
    // Center Button Was Pressed Function.
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        
        
        
    } // END Center Button Was Pressed.
    
    
} // END Class.

extension MapVC: MKMapViewDelegate {
    
}


// MapVC:  

































