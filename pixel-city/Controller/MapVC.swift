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

class MapVC: UIViewController, UIGestureRecognizerDelegate {
    
    /*
     IBOutlets
     */
    
    @IBOutlet weak var mapView: MKMapView!
    
    /*
     Instance Variables
     */
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    
    /*
     Functions
     */
    
    
    /* View Did Load Function. */
    
    override func viewDidLoad() {
        super.viewDidLoad()
            // Set MapView Delegate.
        mapView.delegate = self
            // Set LocationManager Delegate.
        locationManager.delegate = self
            // Call to verify if we have access to location from user.
        configureLocationServices()
            // Add Double Tap Function to Drop Pin.
        doubleTap()
    } // END View Did Load
    
    
    /* Double Tap Function. */
    
    func doubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
    } // END Double Tap
    
    
    /* Center Button Was Pressed Function. */
    
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    } // END Center Button Was Pressed.
    
    
} // END Class.


/*
 Extensions
 */


/*
 MKMapViewDelegate Extension.
 */

extension MapVC: MKMapViewDelegate {
    
    /* View for Annotation Function */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Code so the user location isn't changed, just our pins.
        if annotation is MKUserLocation {
            return nil
        }
        
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "drppablePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    } // End View For Annotation.
    
    /* Center Map On User Location Function. */
    
    func centerMapOnUserLocation() {
        /* Start by creating a constant of the user's location.  If locationManager hasn't determined
         the user's location yet, it will return out of this function until locationManager has it.
         */
        guard let coordinate = locationManager.location?.coordinate else { return }
        // Set up the Region we want to zoom into.
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        // Set region on Map View.
        mapView.setRegion(coordinateRegion, animated: true)
    } // END Center Map On User Location
    
    
    /* Drop Pin Function. */
    @objc func dropPin(sender: UITapGestureRecognizer) {
        removePin() // Clear any pin on map before adding new one.
        
        let touchPoint = sender.location(in: mapView)
            // Converts Screen position to a GPS coordinate
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = DropablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
        
        // Set map centered to our pin drop.
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(touchCoordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    } // END Drop Pin.
    
    
    /* Remove Pin Function */
    func removePin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    } // END Remove Pin.
    
    
} // End MKMapViewDelegate Extension.



/* CLLocationManagerDelegate Extension. */

extension MapVC: CLLocationManagerDelegate {
    
    /* Configure Location Services Function. */
    
        /*
            Will check if we have permission for location, if so it will return location.
            If not, it will request those services.
        */
    
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
    
    
    /* Did Change Authorization Status Function. */
    
        /*
            Called Anytime the mapView changes Authorization (Permission)
        */
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    } // END Did Change Authorization Status.
    
    
} // END CLLocationManagerDelegate.


// MapVC:  

































