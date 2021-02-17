//
//  PhotoLocation.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 03.02.21.
//

import CoreData

class PhotoLocation: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var photos: Set<Photo>
}
