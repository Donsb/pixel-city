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
    let authorizationStatus = CLLocationManager.authorizationStatus()
    
    /*
     Functions
     */
    
    
    // View Did Load Function.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set MapView Delegate.
        mapView.delegate = self
        
        // Set LocationManager Delegate.
        locationManager.delegate = self
        
        // Call to verify if we have access to location from user.
        configureLocationServices()
        
    } // END View Did Load
    
    
    // Center Button Was Pressed Function.
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        
        
        
    } // END Center Button Was Pressed.
    
    
} // END Class.


/*
 Extensions
 */


// MKMapViewDelegate Extension.
extension MapVC: MKMapViewDelegate {
    
} // End MKMapViewDelegate Extension.


// CLLocationManagerDelegate Extension.
extension MapVC: CLLocationManagerDelegate {
    
    /*
     Functions
     */
    
    
    // Configure Location Services Function.
        //-> Will check if we have permission for location, if so it will return location.
            // If not, it will request those services.
    func configureLocationServices() {
        
        // .notDetermined is either user said no or the app doesn't know yet.
        if authorizationStatus == .notDetermined {
            
            // requestAlways will allow location wether in app or not.
            locationManager.requestAlwaysAuthorization()
            
        } else {
            // Simply return out if authorized as nothing to do.
            return
        }
        
    } // END Configure Location Services
    
} // END CLLocationManagerDelegate.


// MapVC:  

































