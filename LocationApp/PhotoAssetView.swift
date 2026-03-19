//
//  PhotoAssetView.swift
//  LocationApp
//
//  Created by Ari Everett on 3/16/26.
//

import SwiftUI

struct PhotoAssetView: View {
    var photo: PhotoAsset
    @Binding var location: Location

    @Environment(\.dismiss) private var dismiss
    @Environment(LocationStore.self) private var store

    var body: some View {
        VStack {
            Spacer()

            photo.image
                .resizable()
                .aspectRatio(contentMode: .fit)

            Spacer()

            Text(location.name)
        }
        .navigationTitle(photo.url.lastPathComponent)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()

                Button(action: {
                    location.remove(asset: photo)
                    store.update(location: location)
                    dismiss()
                }, label: {
                    Label("remove", systemImage: "trash")
                })
            }
        }
    }
}

#Preview {
    
    // semi working preview mode for photoassetview
    
    @Previewable @State var location = Location(
        id: UUID(),
        coordinate: Coordinate2D(latitude: 33.4255, longitude: -111.9400),
        mapDelta: 0.05,
        name: "Tempe",
        description: "Sample preview",
        photos: [
            PhotoAsset(
                id: UUID(),
                filename: "preview.jpg",
                contentType: .jpeg
            )
        ]
    )

    PhotoAssetView(
        photo: location.photos[0],
        location: $location
    )
    .environment(LocationStore())
}
