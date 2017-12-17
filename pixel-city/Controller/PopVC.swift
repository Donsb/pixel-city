//
//  PopVC.swift
//  pixel-city
//
//  Created by Donald Belliveau on 2017-12-16.
//  Copyright © 2017 Donald Belliveau. All rights reserved.
//

import UIKit

class PopVC: UIViewController, UIGestureRecognizerDelegate {
    
    /*
     IBOutlets
     */
    
    @IBOutlet weak var popImageView: UIImageView!
    
    /*
     Instance Variables
     */
    
    var passedImage: UIImage!
    
    /*
     Initializer
     */
    
    /* Init Data Function. */
    
    func initData(forImage image: UIImage) {
        self.passedImage = image
    } // END Init Data
    
    
    
    /*
     Functions
     */
    
    
    /* View Did Load Function. */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popImageView.image = passedImage
        addDoubleTap()
    } // END View Did Load.
    
    
    /* Add Double Tap Function */
    
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(screenWasDoubleTapped))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        view.addGestureRecognizer(doubleTap)
    } // END Add Double Tap.
    
    
    /* Screen Was Double Tapped Function. */
    
    @objc func screenWasDoubleTapped() {
        dismiss(animated: true, completion: nil)
    } // END Screen Was Double Tapped
    
} // END Class.




