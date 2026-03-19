//
//  PhotoGalleryView.swift
//  LocationApp
//
//  Created by Ari Everett on 3/16/26.
//

import SwiftUI
import PhotosUI

struct PhotoGalleryView: View {
    @Binding var location: Location
    @State private var showPicker = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @Environment(LocationStore.self) private var store

    private let gridSize: CGFloat = 120

    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: gridSize), spacing: 4)]
    }

    var body: some View {
        VStack {
            Button(action: {
                showPicker = true
            }, label: {
                Label("Add Photos", systemImage: "photo.badge.plus")
                    .padding(8)
                    .background(Color.white)
                    .background(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(.gray)
                    )
            })
            .photosPicker(isPresented: $showPicker, selection: $selectedItems)

            if location.photos.isEmpty {
                ContentUnavailableView(
                    "No photos",
                    systemImage: "photo.on.rectangle.angled",
                    description: Text("Tap \"Add Photos\" to select a photo from the library.")
                )
            } else {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(location.photos) { asset in
                        NavigationLink(value: asset) {
                            asset.image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .clipped()
                                .aspectRatio(1, contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .onChange(of: selectedItems) { _, _ in
            importSelectedPhotosFromSystemLibrary()
        }
    }

    func importSelectedPhotosFromSystemLibrary() {
        guard !selectedItems.isEmpty else { return }

        Task {
            for item in selectedItems {
                if let asset = try? await item.loadTransferable(type: PhotoAsset.self) {
                    location.add(asset: asset)
                } else {
                    print("Failed to load transferable")
                }
            }

            selectedItems = []
            store.update(location: location)
        }
    }
}
