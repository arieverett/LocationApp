//
//  PlaceSearchView.swift
//  LocationApp
//
//  Created by Ari Everett on 3/2/26.
//

import Foundation
import SwiftUI
import MapKit

struct PlaceSearchView: View {
    @Environment(LocationStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var results: [MKMapItem] = []

    var body: some View {
        NavigationStack {
            List(results, id: \.self) { item in
                Button(action: {
                    addLocation(from: item)
                }) {
                    Text(item.name ?? "Unknown Place")
                }
            }
            .navigationTitle(Text("Search Places"))
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search for a place")
            .onSubmit(of: .search) {
                search()
            }
        }
    }

    func search() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: request)

        Task {
            if let response = try? await search.start() {
                results = response.mapItems
            }
        }
    }

    func addLocation(from item: MKMapItem) {
        let name = item.name ?? "Unknown Place"

        let location = Location(
            id: UUID(),
            coordinate: Coordinate2D(item.placemark.coordinate),
            mapDelta: 0.01,
            name: name,
            description: "",
            photos: []
        )

        store.add(location: location)
        dismiss()
    }
}

#Preview {
    PlaceSearchView()
        .environment(LocationStore())
}
