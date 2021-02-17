//
//  CoreDataManager.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 03.02.21.
//

import UIKit
import CoreData

enum CoreDataManager {
    
    private static let coreDataStack = CoreDataStack.shared
    
    
    //MARK: - Fetch
    
    private static func fetchPhotosCount() -> Int16 {
        let request = Photo.fetchRequest()
        
        do {
            let photos = try coreDataStack.context.fetch(request)
            return Int16(photos.count)-1
        } catch { return .zero }
    }
    
    
    private static func fetchAllPhotos() -> [Photo] {
        let request = Photo.fetchRequest()
        
        do {
            let photos = try coreDataStack.context.fetch(request)
            return photos as! [Photo]
        } catch { return [] }
    }
    
    
    private static func fetchAllPhotoLocations() -> [PhotoLocation] {
        let request = PhotoLocation.fetchRequest()
        
        do {
            let locations = try coreDataStack.context.fetch(request)
            return locations as! [PhotoLocation]
        } catch { return [] }
    }
    
    
    //MARK: - Insert
    
    static func insertPhoto(withDictionary jsonPhoto: JSONDictionary, completion: @escaping () -> ()) {
        coreDataStack.context.perform {
            let photo               = Photo(context: coreDataStack.context)
            
            photo.order             = fetchPhotosCount()
            photo.id                = jsonPhoto["id"] as! String
            photo.title             = jsonPhoto["description"] as? String
            
            let user                = jsonPhoto["user"] as! JSONDictionary
            photo.username          = user["name"] as? String
            
            let width               = jsonPhoto["width"] as! Double
            let height              = jsonPhoto["height"] as! Double
            photo.ratio             = height / width //width 1:ratio height
            
            let links               = jsonPhoto["links"] as! JSONDictionary
            photo.unsplashURL       = links["html"] as! String
                
            let urls                = jsonPhoto["urls"] as! JSONDictionary
            photo.imageURL          = urls["small"] as! String
            photo.imageURLMap       = urls["thumb"] as! String
            
            configurePhotoLocation(of: photo, jsonPhoto: jsonPhoto)
            
            coreDataStack.saveContext()
            completion()
        }
    }
    
    
    static private func configurePhotoLocation(of photo: Photo, jsonPhoto: JSONDictionary) {
        let location            = jsonPhoto["location"] as! JSONDictionary
        let locationName        = location["name"] as! String
        
        let position            = location["position"] as! JSONDictionary
        let locationLatitude    = position["latitude"] as! Double
        let locationLongitude   = position["longitude"] as! Double
        
        let existingLocations   = fetchAllPhotoLocations()
        
        if let existingLocation = existingLocations.filter({ $0.latitude == locationLatitude && $0.longitude == locationLongitude }).first {
            photo.location = existingLocation
            existingLocation.photos.insert(photo)
        } else {
            let photoLocation       = PhotoLocation(context: coreDataStack.context)
            
            photoLocation.latitude  = locationLatitude
            photoLocation.longitude = locationLongitude
            photoLocation.name      = locationName
            photoLocation.photos.insert(photo)
            
            photo.location = photoLocation
        }
    }
    
    
    //MARK: - Change
    
    static func movePhoto(items: [Photo], sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        var photos = items
        
        coreDataStack.context.perform {
            let photo = photos[sourceIndexPath.row]
            photos.remove(at: sourceIndexPath.row)
            photos.insert(photo, at: destinationIndexPath.row)

            for (newOrder, photo) in photos.enumerated() {
                changePhotoOrder(photo, with: Int16(newOrder))
            }

            coreDataStack.saveContext()
        }
    }
    
    
    static func changePhotoOrder(_ photo: Photo, with newOrder: Int16) {
        photo.order = newOrder
    }
    
    
    //MARK: - Delete
    
    static func deletePhoto(photo: Photo) {
        coreDataStack.context.perform {
            let photos = fetchAllPhotos()
            
            for p in photos {
                if p.order > photo.order {
                    changePhotoOrder(p, with: p.order-1)
                }
            }
            
            coreDataStack.context.delete(photo)
            coreDataStack.saveContext()
        }
    }
}
