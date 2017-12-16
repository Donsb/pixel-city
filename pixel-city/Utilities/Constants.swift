//
//  Constants.swift
//  pixel-city
//
//  Created by Donald Belliveau on 2017-12-16.
//  Copyright © 2017 Donald Belliveau. All rights reserved.
//

import Foundation

/*
 Constants
 */

let API_KEY = "58740c65057008e5123e313a78f7fb2d"

/*
 URLs
 */

/* FLICKER_URL Function. */

func FLICKR_URL(forApiKey key: String, withAnnotation annotation: DropablePin, andNumberOfPhotos number: Int)-> String {
    return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(API_KEY)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=km&per_page=\(number)&format=json&nojsoncallback=1"
} // END FLICKER_URL.




// Constants:  






