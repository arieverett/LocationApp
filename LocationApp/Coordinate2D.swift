//
//  Coordinate2D.swift
//  LocationApp
//
//  Created by Ari Everett on 2/23/26.
//

import Foundation
import CoreLocation

struct Coordinate2D: Codable, Equatable, Hashable {
    var latitude: Double
    var longitude: Double
    
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(_ coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}
