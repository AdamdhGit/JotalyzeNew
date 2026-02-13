//
//  JournalThumbnailView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 2/13/26.
//

import SwiftUI
import Foundation
import ImageIO

final class ImageCache {
    static let shared = ImageCache()
    let cache = NSCache<NSString, UIImage>()
}

struct JournalThumbnailView: View {
    let entry: JournalEntry
    @State private var image: UIImage?
    @State private var isLoading = true
    /*
        .frame(maxHeight: 300)
        .padding(.trailing, 40)
        .padding(.vertical)
    */

    var body: some View {
        Group {
            
            if isLoading {
                    ProgressView()
                } else if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    // small placeholder
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                        .opacity(0.5)
                }
            
            
        }
        .onAppear {
            loadThumbnail()
        }
    }

    private func loadThumbnail() {
        // 1️⃣ Check if image is already cached by entry ID
        if let cachedByID = ImageCache.shared.cache.object(forKey: entry.id.uuidString as NSString) {
            self.image = cachedByID
            self.isLoading = false
            return
        }

        // 2️⃣ New or old entry with base64: decode first
        if let imageDataString = entry.imageData,
           let data = Data(base64Encoded: imageDataString),
           let uiImage = UIImage(data: data) {
            
            self.image = uiImage
            ImageCache.shared.cache.setObject(uiImage, forKey: entry.id.uuidString as NSString)
            self.isLoading = false

            // ✅ Upgrade: save decoded image to Images folder if not already
            if entry.thumbnailPath == nil || entry.thumbnailPath?.isEmpty == true {
                let imagesDir = JournalManager.shared.imagesDirectory()
                let fileURL = imagesDir.appendingPathComponent("\(entry.id).png")
                
                if let pngData = uiImage.pngData() {
                    try? pngData.write(to: fileURL, options: .completeFileProtection)
                    
                    var updatedEntry = entry
                    updatedEntry.thumbnailPath = fileURL.lastPathComponent
                    JournalManager.shared.saveJournalEntry(updatedEntry)
                    
                }
            }

            return
        }

        // 3️⃣ Show placeholder immediately while disk image loads
        //self.image = UIImage(systemName: "photo")
        self.isLoading = false

        
        JournalManager.shared.loadingImageCount += 1
        // 4️⃣ Load disk image in background
        DispatchQueue.global(qos: .userInitiated).async {
            
            defer {
                    DispatchQueue.main.async {
                        JournalManager.shared.loadingImageCount -= 1
                    }
                }
            
            guard let fileURL = JournalManager.shared.getImageURL(from: entry.thumbnailPath ?? entry.imagePath) else {
                return
            }

            if let cachedByPath = ImageCache.shared.cache.object(forKey: fileURL.path as NSString) {
                DispatchQueue.main.async {
                    self.image = cachedByPath
                }
                return
            }

            let loadedImage = downsampleImage(at: fileURL, to: CGSize(width: 300, height: 300))
            if let loadedImage = loadedImage {
                ImageCache.shared.cache.setObject(loadedImage, forKey: fileURL.path as NSString)
                ImageCache.shared.cache.setObject(loadedImage, forKey: entry.id.uuidString as NSString)

                DispatchQueue.main.async {
                    self.image = loadedImage
                }
                
              
            }
        }
    }


    func downsampleImage(at url: URL, to pointSize: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        let options = [
            kCGImageSourceShouldCache: false
        ] as CFDictionary

        guard let source = CGImageSourceCreateWithURL(url as CFURL, options) else { return nil }

        let maxDimension = max(pointSize.width, pointSize.height) * scale

        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimension
        ] as CFDictionary

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else { return nil }

        return UIImage(cgImage: cgImage)
    }
    
}
