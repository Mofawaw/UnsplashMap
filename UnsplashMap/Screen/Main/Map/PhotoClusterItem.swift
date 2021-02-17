//
//  PhotoClusterItem.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 09.02.21.
//

import GoogleMapsUtils

class PhotoClusterItem: NSObject, GMUClusterItem {
    
    let position: CLLocationCoordinate2D
    let photo: Photo
    
    init(photo: Photo) {
        self.photo      = photo
        self.position   = photo.cLLocationCoordinate2D
    }
}
