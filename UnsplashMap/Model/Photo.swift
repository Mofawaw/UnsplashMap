//
//  Photo.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 03.02.21.
//

import CoreData

class Photo: NSManagedObject {
    
    @NSManaged var order: Int16
    @NSManaged var id: String
    @NSManaged var title: String?
    @NSManaged var username: String?
    @NSManaged var ratio: Double
    @NSManaged var unsplashURL: String
    @NSManaged var imageURL: String
    @NSManaged var imageURLMap: String
    @NSManaged var location: PhotoLocation
    
    
    //Delete PhotoLocation if all photos are gone at that location
    override func prepareForDeletion() {
        if location.photos.filter({ !$0.isDeleted }).isEmpty {
            managedObjectContext?.delete(location)
        }
    }
}


extension Photo {
    
    var cLLocation: CLLocation {
        return CLLocation(latitude: location.latitude, longitude: location.longitude)
    }
    
    
    var cLLocationCoordinate2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
}


