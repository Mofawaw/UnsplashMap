//
//  MapVC.swift
//  UnsplashMapped
//
//  Created by Kai Zheng on 02.02.21.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils
import CoreData

class MapVC: UIViewController {
    
    let locationButton = UMCircleButton(size: .medium, appearance: .light, symbol: SFSymbol.currentLocation)
    
    var mapView = GMSMapView.map(withFrame: .zero, camera: .default)
    var clusterManager: GMUClusterManager!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var fetchedResultsController: NSFetchedResultsController<Photo>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UMColor.whiteToDarkGray
        
        configureMapView()
        configureCurrentLocation()
        
        configureFetchResultsController()
        fetchCoreData()
        
        configureClusterManager()
        configureClusters()
    }
    
    
    //MARK: - MapView
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setMapStyle()
    }
    
    
    private func configureMapView() {
        view = mapView
        setMapStyle()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    private func setMapStyle() {
        var styleURL: URL?
        
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:  styleURL = UMBundle.defaultMapStyle
        case .dark:                 styleURL = UMBundle.defaultDarkMapStyle
        @unknown default: break
        }
        
        do {
            if let styleURL = styleURL {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }
        } catch {
            print(error)
        }
    }
    
    
    //MARK: - Location
    
    private func configureCurrentLocation() {
        locationManager.delegate = self
        
        mapView.addSubview(locationButton)
        
        NSLayoutConstraint.activate([
            locationButton.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 10),
            locationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -UMLayout.padding),
            locationButton.heightAnchor.constraint(equalToConstant: locationButton.frame.size.height),
            locationButton.widthAnchor.constraint(equalToConstant: locationButton.frame.size.width)
        ])
        
        locationButton.addTarget(self, action: #selector(locationButtonAction), for: .touchUpInside)
    }
    
    
    @objc private func locationButtonAction() {
        LocationManager.shared.requestLocationAuthorization()
        
        if let location = currentLocation {
            cameraToLocation(location)
        }
    }
    
    
    func cameraToLocation(_ location: CLLocation) {
        let newLatitude = location.coordinate.latitude
        let newLongitude = location.coordinate.longitude

        mapView.camera = GMSCameraPosition(latitude: newLatitude, longitude: newLongitude, zoom: 8)
    }
    
    
    //MARK: - Photos Data
    
    private func configureFetchResultsController() {
        let request: NSFetchRequest<Photo> = NSFetchRequest(entityName: "Photo")
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)

        fetchedResultsController.delegate = self
    }
    
    
    private func fetchCoreData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            self.showPopupVC(title: "Error", body: error.localizedDescription)
        }
    }
    
    
    //MARK: - Map Clustering
    
    
    private func configureClusterManager() {
        let buckets: [NSNumber] = [2, 3, 4, 5, 10]
        let bucketColors        = Array<UIColor>(repeating: .black, count: 5)
        
        let iconGenerator       = GMUDefaultClusterIconGenerator(buckets: buckets, backgroundColors: bucketColors)
        let algorithm           = GMUNonHierarchicalDistanceBasedAlgorithm()
        
        let renderer            = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate       = self
        
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        clusterManager.setDelegate(self, mapDelegate: nil)
    }
    
    
    private func configureClusters() {
        let photos: [Photo] = fetchedResultsController.fetchedObjects ?? []
        
        for photo in photos {
            let clusterItem = PhotoClusterItem(photo: photo)
            clusterManager.add(clusterItem)
        }
        
        clusterManager.cluster()
    }
}


extension MapVC: GMUClusterRendererDelegate {
    
    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
        switch object {
        case let clusterItem as PhotoClusterItem:
            return PhotoMarker(photo: clusterItem.photo)
        default:
            return nil
        }
    }
}


extension MapVC: GMUClusterManagerDelegate {
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap clusterItem: GMUClusterItem) -> Bool {
        if let clusterItem = clusterItem as? PhotoClusterItem {
            let photoModalVC = PhotoModalVC(photo: clusterItem.photo)
            self.showModalVC(customChildVC: photoModalVC, height: .half)
        }
        return true
    }
}


extension MapVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            mapView.isMyLocationEnabled = true
            
            currentLocation = location
            locationManager.stopUpdatingLocation()
            
            if mapView.camera == .default {
                cameraToLocation(location)
            }
        }
    }
}


extension MapVC: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:   controllerDidInsert(newIndexPath: newIndexPath!)
        case .delete:   controllerDidDelete()
        default: break
        }
    }
    
    
    private func controllerDidInsert(newIndexPath indexPath: IndexPath) {
        let photo       = fetchedResultsController.object(at: indexPath)
        let clusterItem = PhotoClusterItem(photo: photo)
        
        DispatchQueue.main.async {
            self.clusterManager.add(clusterItem)
            self.cameraToLocation(CLLocation(latitude: photo.location.latitude, longitude: photo.location.longitude))
            self.clusterManager.cluster()
        }
    }
    
    
    private func controllerDidDelete() {
        DispatchQueue.main.async {
            self.clusterManager.clearItems()
            self.configureClusters()
        }
    }
}


