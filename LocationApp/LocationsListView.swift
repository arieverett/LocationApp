//
//  LocationsListView.swift
//  LocationApp
//
//  Created by Ari Everett on 2/23/26.
//

import SwiftUI

struct LocationsListView: View {
    @Environment(LocationStore.self) private var store
    @State private var showAddLocation = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.locations) { location in
                    NavigationLink(value: location) {
                        Text(location.name)
                    }
                }
                .onDelete(perform: deleteLocations)
                .onMove(perform: moveLocations)
            }
            .navigationTitle("Locations")
            .navigationDestination(for: Location.self) { location in
                LocationView(location: location)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if !store.locations.isEmpty {
                        EditButton()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAddLocation = true
                    }, label: {
                        Label("", systemImage: "plus")
                    })
                }
            }
            .sheet(isPresented: $showAddLocation) {
                NewLocationView()
            }
            .overlay {
                if store.locations.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Locations", systemImage: "mappin.slash")
                    })
                }
            }
        }
    }
    
    func deleteLocations(offsets: IndexSet) {
        store.delete(at: offsets)
    }
    
    func moveLocations(from source: IndexSet, to destination: Int) {
        store.move(from: source, to: destination)
    }
}

struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsListView()
            .environment(LocationStore())
    }
}
