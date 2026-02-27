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
    
    private let archiveURL = URL.documentsDirectory.appendingPathComponent("locations.plist")
    
    init() {
        load()
    }
    
    func add(location: Location) {
        locations.append(location)
        save()
    }
    
    func delete(at offsets: IndexSet) {
        locations.remove(atOffsets: offsets)
        save()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        locations.move(fromOffsets: source, toOffset: destination)
        save()
    }
    
    private func save() {
        do {
            let codedLocations = try PropertyListEncoder().encode(locations)
            try codedLocations.write(to: archiveURL)
        } catch {
            print("Failed to save locations: \(error.localizedDescription)")
        }
    }
    
    private func load() {
        guard FileManager.default.fileExists(atPath: archiveURL.path) else {
            return
        }
        
        do {
            let codedLocations = try Data(contentsOf: archiveURL)
            locations = try PropertyListDecoder().decode([Location].self, from: codedLocations)
        } catch {
            print("Failed to load locations: \(error.localizedDescription)")
        }
    }
}
