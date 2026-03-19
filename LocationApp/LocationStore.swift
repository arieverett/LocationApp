//
//  LocationStore.swift
//  LocationApp
//
//  Created by Ari Everett on 2/23/26.
//

import Foundation
import SwiftUI

@Observable
class LocationStore {
    var locations: [Location] = []

    // added this initializer to default to a location and avoid white screen of death on start up
    init() {
        if let savedLocations = load() {
            locations = savedLocations
        } else {
            locations = [Location.example()]
        }
    }

    func add(location: Location) {
        locations.append(location)
        save()
    }

    func update(location: Location) {
        if let index = locations.firstIndex(where: { $0.id == location.id }) {
            locations[index] = location
            save()
        }
    }

    func remove(atOffsets offsets: IndexSet) {
        for offset in offsets {
            for photo in locations[offset].photos {
                photo.deleteFile()
            }
        }

        locations.remove(atOffsets: offsets)
        save()
    }

    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        locations.move(fromOffsets: source, toOffset: destination)
        save()
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(locations)
            UserDefaults.standard.set(data, forKey: "SavedLocations")
        } catch {
            print("Failed to save locations: \(error)")
        }
    }

    func load() -> [Location]? {
        guard let data = UserDefaults.standard.data(forKey: "SavedLocations") else {
            return nil
        }

        do {
            return try JSONDecoder().decode([Location].self, from: data)
        } catch {
            print("Failed to load locations: \(error)")
            return nil
        }
    }
}
