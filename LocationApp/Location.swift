//
//  Location.swift
//  LocationApp
//
//  Created by Ari Everett on 2/23/26.
//

import Foundation
import SwiftUI
import MapKit

struct Location: Identifiable, Codable, Hashable {
    var id: UUID
    var coordinate: Coordinate2D
    var mapDelta: Double
    var name: String
    
    var position: MapCameraPosition {
        get {
            let region = MKCoordinateRegion(center: coordinate.clLocationCoordinate2D, span: MKCoordinateSpan(latitudeDelta: mapDelta, longitudeDelta: mapDelta))
            return MapCameraPosition.region(region)
        }
        set {
            // left blank intentionally
        }
    }
    
    static func example() -> Location {
        let coordinate = Coordinate2D(latitude: 33.4255, longitude: -111.9400)
        let tempe = Location(id: UUID(), coordinate: coordinate, mapDelta: 0.05, name: "Tempe")
        return tempe
    }
}
