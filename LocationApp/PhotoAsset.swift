//
//  PhotoAsset.swift
//  LocationApp
//
//  Created by Ari Everett on 3/16/26.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct PhotoAsset: Identifiable, Codable, Equatable, Hashable {
    var id: UUID
    var filename: String
    var contentType: UTType

    var url: URL {
        URL.documentsDirectory
            .appending(path: "Photos", directoryHint: .isDirectory)
            .appending(path: filename)
    }

    var uiImage: UIImage {
        do {
            let data = try Data(contentsOf: url)
            if let photo = UIImage(data: data) {
                return photo
            }
        } catch {
            print(error)
        }

        return UIImage(systemName: "photo")!
    }

    var image: Image {
        Image(uiImage: uiImage)
    }
}

extension PhotoAsset: Transferable {
    
    // This computed property can contain multiple representations for different
    // content types. It determines what kind of representation will be used for
    // the transfer for a content type.

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(importedContentType: .jpeg) { received in
            await copyReceivedFile(received, contentType: .jpeg)
        }

        FileRepresentation(importedContentType: .png) { received in
            await copyReceivedFile(received, contentType: .png)
        }

        FileRepresentation(importedContentType: .heic) { received in
            await copyReceivedFile(received, contentType: .heic)
        }
    }

    static func copyReceivedFile(_ received: ReceivedTransferredFile, contentType: UTType) -> PhotoAsset {
        let now = Date().formatted(
            Date.ISO8601FormatStyle()
                .timeSeparator(.omitted)
                .dateSeparator(.dash)
        )

        let name = "\(now)-\(received.file.lastPathComponent)"
        let photosURL = URL.documentsDirectory.appending(path: "Photos", directoryHint: .isDirectory)

        if !FileManager.default.fileExists(atPath: photosURL.path()) {
            try? FileManager.default.createDirectory(at: photosURL, withIntermediateDirectories: true)
        }

        let url = photosURL.appending(path: name)
        try? FileManager.default.copyItem(at: received.file, to: url)

        return PhotoAsset(id: UUID(), filename: name, contentType: contentType)
    }

    func deleteFile() {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Failed to remove file: \(error)")
        }
    }
}
