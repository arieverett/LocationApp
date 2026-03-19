//
//  LocationView.swift
//  LocationApp
//
//  Created by Ari Everett on 2/23/26.
//

import SwiftUI
import MapKit

struct LocationView: View {
    @State var location: Location
    @Environment(LocationStore.self) private var store

    var body: some View {
        ScrollView {
            VStack {
                TextField("name", text: $location.name)
                    .textFieldStyle(.roundedBorder)

                Map(position: $location.position)
                    .frame(minHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                TextField("description", text: $location.description, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)

                PhotoGalleryView(location: $location)
            }
            .padding()
        }
        .navigationTitle(location.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: PhotoAsset.self) { asset in
            PhotoAssetView(photo: asset, location: $location)
        }
        .onDisappear {
            store.update(location: location)
        }
        .onChange(of: location.name) { oldValue, newValue in
            print("named changed to: \(newValue)")
        }
    }
}

#Preview {
    LocationView(location: .example())
        .environment(LocationStore())
}
