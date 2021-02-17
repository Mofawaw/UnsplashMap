//
//  LocationManager.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 07.02.21.
//

import UIKit
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()
    private override init() { super.init() }
    
    private var locationManager: CLLocationManager = CLLocationManager()

    
    func requestLocationAuthorization() {
        locationManager.delegate = self
        let currentStatus = CLLocationManager.authorizationStatus()

        switch currentStatus {
        case .authorizedWhenInUse, .authorizedAlways:   return
        case .notDetermined:                            locationManager.requestWhenInUseAuthorization()
        default:
            UIApplication.getTopViewController()?.showPopupVC(title: "Failed", body: "Please make sure to grant permissions to your current location.") {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
    }
}
