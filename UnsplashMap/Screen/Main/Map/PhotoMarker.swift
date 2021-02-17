//
//  PhotoMarker.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 07.02.21.
//

import UIKit
import GoogleMaps

class PhotoMarker: GMSMarker {
    
    init(photo: Photo) {
        super.init()
        
        let imageView = PhotoImageView()
        imageView.downloadImage(photo: photo, size: .map)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        self.position = photo.cLLocationCoordinate2D
        self.iconView = imageView
    }
}
