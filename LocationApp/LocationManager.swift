//
//  LocationManager.swift
//  LocationApp
//
//  Created by Ari Everett on 2/18/26.
//

import Foundation
import CoreLocation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    var currentLocation: CLLocation?
    var authorizationStatus: CLAuthorizationStatus
    
    private let manager = CLLocationManager()
    
    override init() {
        authorizationStatus = manager.authorizationStatus
        super.init( )
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation( )
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {print("Location error: \(error.localizedDescription)")
    }
    
    // added this to keep authorizationStatus updated
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}
