//
//  LocationAppApp.swift
//  LocationApp
//
//  Created by Ari Everett on 2/18/26.
//

import SwiftUI

@main
struct LocationAppApp: App {
    @State private var store = LocationStore()
    var body: some Scene {
        WindowGroup {
            LocationsListView()
                .environment(store)
        }
    }
}
