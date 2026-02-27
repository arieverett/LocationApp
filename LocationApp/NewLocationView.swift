//
//  NewLocationView.swift
//  LocationApp
//
//  Created by Ari Everett on 2/18/26.
//

import SwiftUI
import CoreLocation
import MapKit

struct NewLocationView: View {
    @Environment(LocationStore.self) private var store
    @State private var locationManager = LocationManager()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Add by Device Location") {
                    Button(action: {
                        requestCurrentLocation()
                    }, label: {
                        Label("Use Current Location", systemImage: "location.fill")
                    })
                }
            }
            .navigationTitle("Add Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onChange(of: locationManager.currentLocation) { _, newValue in
            print("Update to currentlocation")
            if let coordinate = newValue?.coordinate {
                createLocation(coordinate: coordinate)
            }
        }
        .onAppear {
            locationManager.requestPermission()
        }
    }

    private func requestCurrentLocation() {
        locationManager.requestLocation()
    }

    private func createLocation(coordinate: CLLocationCoordinate2D) {
        Task {
            var name = "Current location"
            
            if let currentLocation = locationManager.currentLocation,
               let request = MKReverseGeocodingRequest(location: currentLocation) {
                let results = try? await request.mapItems
                if let firstItem = results?.first,
                   let locationName = firstItem.name {
                    name = locationName
                }
            }
        
            
            let coord2d = Coordinate2D(coordinate)
            let location = Location(id: UUID(), coordinate: coord2d, mapDelta: 0.01, name: name)
            store.add(location: location)
            dismiss()
        }
    }
}

struct NewLocationView_Previews: PreviewProvider {
    static var previews: some View {
        NewLocationView()
            .environment(LocationStore())
    }      
}
