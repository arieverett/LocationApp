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
    var description: String
    var photos: [PhotoAsset]

    var position: MapCameraPosition {
        get {
            let region = MKCoordinateRegion(
                center: coordinate.clLocationCoordinate2D,
                span: MKCoordinateSpan(latitudeDelta: mapDelta, longitudeDelta: mapDelta)
            )
            return .region(region)
        }
        set {
            // left blank intentionally
        }
    }

    mutating func add(asset: PhotoAsset) {
        photos.append(asset)
    }

    mutating func remove(asset: PhotoAsset) {
        if let index = photos.firstIndex(of: asset) {
            asset.deleteFile()
            photos.remove(at: index)
        }
    }

    static func example() -> Location {
        let coordinate = Coordinate2D(latitude: 33.4255, longitude: -111.9400)

        let tempe = Location(
            id: UUID(),
            coordinate: coordinate,
            mapDelta: 0.05,
            name: "Tempe",
            description: "",
            photos: []
        )

        return tempe
    }
}
