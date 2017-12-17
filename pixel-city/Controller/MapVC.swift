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
import Alamofire
import AlamofireImage

class MapVC: UIViewController, UIGestureRecognizerDelegate {
    
    /*
     IBOutlets
     */
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pullUpView: UIView!
    @IBOutlet weak var pullUpViewHeightConstraint: NSLayoutConstraint!
    
    /*
     Instance Variables
     */
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    var screenSize = UIScreen.main.bounds
    var spinner: UIActivityIndicatorView?
    var progressLbl: UILabel?
    var flowLayout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView?
    var imageUrlArray = [String]()
    var imageArray = [UIImage]()
    
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
            // Instantiate Collection View.
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
            // Set up Collection View Cell to use our custom cell class.
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
            // Set CollectionView delegate to self.
        collectionView?.delegate = self
            // Set CollectionView DataSource to self.
        collectionView?.dataSource = self
            // Add a background View so we can see it when pop up occurs.
        collectionView?.backgroundColor = #colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)
            // Set SourceRect from 3D Touch to collectionView.
        registerForPreviewing(with: self, sourceView: collectionView!)
            // Add CollectionView to our Pull Up View.
        pullUpView.addSubview(collectionView!)
    } // END View Did Load
    
    
    /* Double Tap Function. */
    
    func doubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
    } // END Double Tap
    
    
    /* Add Swipe Function */
    
    func addSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)
    } // END Swipe Function.
    
    
    /* Animate View Down Function. */
    
    @objc func animateViewDown() {
        cancelAllSessions()
        imageUrlArray = [] // Clear image URL array
        imageArray = [] // Clear images from Array
        pullUpViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    } // END Animate View Down.
    
    
    /* Animate View Function. */
    
    func animateView() {
        
        pullUpViewHeightConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    } // END Animate View Function.
    
    
    /* Add Spinner Function */
    
    func addSpinner() {
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (screenSize.width / 2) - ((spinner?.frame.width)! / 2), y: 150)
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        spinner?.startAnimating()
        collectionView?.addSubview(spinner!)
    } // END Add Spinner.
    
    
    /* Remove Spinner Function */
    
    func removeSpinner() {
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    } // END Remove Spinner.
    
    
    /* Add Preogress Lable Function. */
    
    func addProgressLbl() {
        progressLbl = UILabel()
        progressLbl?.frame = CGRect(x: (screenSize.width / 2) - 120, y: 175, width: 240, height: 40)
        progressLbl?.font = UIFont(name: "Avenir", size: 14)
        progressLbl?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        progressLbl?.textAlignment = .center
        collectionView?.addSubview(progressLbl!)
    } // END Add Preogress Lable.
    
    
    /* Remove Progress Label Function. */
    
    func removeLbl() {
        if progressLbl != nil {
            progressLbl?.removeFromSuperview()
        }
    } // END Remove Label.
    
    
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
        removeSpinner() // Removes Spinner if there is one there.
        removeLbl() // Remove Label if there is one.
        cancelAllSessions() // Cancel any downloading images if they add a new pin before the 1st was finished.
        imageUrlArray = [] // Clear image URL array
        imageArray = [] // Clear images from Array
        collectionView?.reloadData() // Reload Data.
        
        animateView()
        addSwipe()
        addSpinner()
        addProgressLbl()
        
        let touchPoint = sender.location(in: mapView)
            // Converts Screen position to a GPS coordinate
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = DropablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
        
        // Set map centered to our pin drop.
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(touchCoordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
        retreiveUrls(forAnnotation: annotation) { (finished) in
            if finished {
                self.retreiveImages(handler: { (finished) in
                    if finished {
                        self.removeSpinner()
                        self.removeLbl()
                        self.collectionView?.reloadData()
                    }
                })
            }
        }
    } // END Drop Pin.
    
    
    /* Remove Pin Function */
    func removePin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    } // END Remove Pin.
    
    
    /*  */
    
    func retreiveUrls(forAnnotation annotation: DropablePin, handler: @escaping (_ status: Bool)-> ()) {
        
        // Web Request
        Alamofire.request(FLICKR_URL(forApiKey: API_KEY, withAnnotation: annotation, andNumberOfPhotos: 40)).responseJSON { (response) in
            guard let json = response.result.value as? Dictionary<String, Any> else { return }
            do {
                let photosDict = try json["photos"] as! Dictionary<String, Any>
                let photosDictArray = try photosDict["photo"] as! [Dictionary<String, Any>]
                for photo in photosDictArray {
                    // See Pages Doc "iOS Flickr & JSON" on how to get the needed URL below.
                    let postUrl = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!)_z_d.jpg"
                    // https://farm5.staticflickr.com/4646/39065500182_8f079dd558_z_d.jpg Example.
                    self.imageUrlArray.append(postUrl)
                }
            } catch {
                debugPrint(error as Any)
            }
            handler(true)
        }
    } // END Retreive URLs.
    
    
    /* Retreive Images Function. */
    
    func retreiveImages(handler: @escaping (_ status: Bool)-> ()) {
        
        for url in imageUrlArray {
            Alamofire.request(url).responseImage(completionHandler: { (response) in
                guard let image = response.result.value else { return }
                self.imageArray.append(image)
                self.progressLbl?.text = "\(self.imageArray.count)/40 IMAGES DOWNLOADED"
                
                if self.imageArray.count == self.imageUrlArray.count {
                    handler(true)
                }
            })
        }
        
    } // END Retreive Images
    
    
    /* Cancel All Sessions Function. */
    
    func cancelAllSessions() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            // sessionDataTask,... are from the Alamofire.
            sessionDataTask.forEach({ $0.cancel() })
            
            /*
             
             NOTE:
             $0 is a temp variable placement.  The above code is the same as typing
             for task in sessionDataTask{
                task.cancel()
             }
             $0 is the same as the temp var task.
             
             */
            downloadData.forEach({ $0.cancel() })
            // We don't do uploadData.cancel as our app doesn't upload data.
        }
    } // END Cancel All Sessions.
    
    
}
// End MKMapViewDelegate Extension.



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
    
    
}
// END CLLocationManagerDelegate.



/* CollectionView Delegate & DataSource Extension */

extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Number Of Sections Function.
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    } // END Number Of Sections.
    
    
    // Number Of Items In Section Function.
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    } // END Number Of Items In Section.
    
    
    // Cell For Item At Index Path Function.
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        let imageFromIndex = imageArray[indexPath.row]
        let imageView = UIImageView(image: imageFromIndex)
        cell.addSubview(imageView)
        return cell
    } // Cell For Item At Index Path.
    
    
    /* Did Select Item At Function */
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "PopVC") as? PopVC else { return }
        popVC.initData(forImage: imageArray[indexPath.row])
        present(popVC, animated: true, completion: nil)
    } // END Did Select Item At.
    
    
}
// END CollectionView Delegate & DataSource.



/* 3D Touch Extension. */

extension MapVC: UIViewControllerPreviewingDelegate {
    
    /* View Controller For Location Function */
        //-> Full Puch to present PopVC.
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView?.indexPathForItem(at: location), let cell = collectionView?.cellForItem(at: indexPath) else { return nil }
        
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "PopVC") as? PopVC else { return nil }
        
        popVC.initData(forImage: imageArray[indexPath.row])
        
        previewingContext.sourceRect = cell.contentView.frame
        
        return popVC
    } // END View Controller For Location.
    
    
    /* View Controller To Commit Function. */
        //-> The small press to peak at the image.
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
        
        /*
         
         NOTE:
         viewControllerToCommit.  It gets it from the previewingContext function.  In that
         one, we set up popVC.  So, here it is being passed popVC into viewControllerToCommit.
         
         */
        
    } // View Controller To Commit
    
    
} // END 3D Touch Extension.


/*
 
 NOTE:
 You can find all the information for the Flicker API
 at the following address: https://www.flickr.com/services/developer.
 
 */




