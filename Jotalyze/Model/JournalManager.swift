//
//  JournalManager.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 10/11/24.
//

import Foundation
import UIKit

@Observable class JournalManager: Observable {
    static let shared = JournalManager()
    //shares the journalManager class itself to access anywhere but the var below is still the data being used and can be published since its a @Observable class.
    
    var loadingImageCount = 0
    var isLoadingImages: Bool {
        loadingImageCount > 0
    }
    
    var journalEntries = [JournalEntry]()
    
    var isLoadingEntries: Bool = true
    
    func imagesDirectory() -> URL {
        let documentsDirectory = getDocumentsDirectory()
        let imagesDir = documentsDirectory.appendingPathComponent("Images")
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: imagesDir.path) {
            do {
                try fileManager.createDirectory(at: imagesDir, withIntermediateDirectories: true, attributes: [.protectionKey: FileProtectionType.complete])
            } catch {
                print("Error creating Images directory: \(error)")
            }
        }
        return imagesDir
    }
    
    func saveImage(_ image: UIImage) throws -> (imagePath: String, thumbnailPath: String?) {
        let imagesDir = imagesDirectory()
        let uuid = UUID().uuidString
        
        let imageURL = imagesDir.appendingPathComponent("\(uuid).jpg")
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            throw NSError(domain: "JournalManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data"])
        }
        try imageData.write(to: imageURL, options: .completeFileProtection)
        
        // Create thumbnail
        let maxThumbnailDimension: CGFloat = 200
        let aspectRatio = image.size.width / image.size.height
        var thumbnailSize: CGSize
        if aspectRatio > 1 {
            thumbnailSize = CGSize(width: maxThumbnailDimension, height: maxThumbnailDimension / aspectRatio)
        } else {
            thumbnailSize = CGSize(width: maxThumbnailDimension * aspectRatio, height: maxThumbnailDimension)
        }
        
        UIGraphicsBeginImageContextWithOptions(thumbnailSize, false, 0)
        image.draw(in: CGRect(origin: .zero, size: thumbnailSize))
        let thumbnailImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var thumbnailPath: String? = nil
        if let thumbnail = thumbnailImage, let thumbnailData = thumbnail.jpegData(compressionQuality: 0.7) {
            let thumbnailURL = imagesDir.appendingPathComponent("\(uuid)_thumb.jpg")
            try thumbnailData.write(to: thumbnailURL, options: .completeFileProtection)
            thumbnailPath = thumbnailURL.path
        }
        
        return (imageURL.path, thumbnailPath)
    }
    
    func saveJournalEntry(_ entry: JournalEntry) {
        let fileURL = getDocumentsDirectory().appendingPathComponent("\(entry.id).json")
        
        do {
            var entryToSave = entry
            
            // Attempt to add imagePath and thumbnailPath if present on JournalEntry
            // This assumes JournalEntry conforms to Codable with optional imagePath and thumbnailPath properties.
            // If not, this will not affect the JSON encoding.
            
            let jsonData = try JSONEncoder().encode(entryToSave)
            
            try jsonData.write(to: fileURL, options: .completeFileProtection)
        } catch {
            print(error)
        }
    }
    
    func refreshEntries() async {
        let fileManager = FileManager.default
        let documentsDirectory = getDocumentsDirectory()
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            
            // Decode entries on background queue
            let entries: [JournalEntry] = try await withCheckedThrowingContinuation { continuation in
                DispatchQueue.global(qos: .userInitiated).async {
                    var loadedEntries = [JournalEntry]()
                    for fileURL in fileURLs where fileURL.pathExtension == "json" {
                        if let jsonData = try? Data(contentsOf: fileURL),
                           let journalEntry = try? JSONDecoder().decode(JournalEntry.self, from: jsonData) {
                            loadedEntries.append(journalEntry)
                        }
                    }
                    continuation.resume(returning: loadedEntries)
                }
            }
            
            await MainActor.run {
                self.journalEntries = entries
                self.isLoadingEntries = false
            }
            
        } catch {
            print("Error reading files from Documents Directory: \(error)")
        }
    }
    
    func getAllJournalEntries() {
        Task {
            await refreshEntries()
        }
    }
    
    func loadJournalEntry(id: UUID) -> JournalEntry? {
        //for drilled in view if i load a specific one.
        let fileURL = getDocumentsDirectory().appendingPathComponent("\(id).json")
        
        do {
            // Read the encrypted data from the file
            let jsonData = try Data(contentsOf: fileURL)
            
            // Decode the JSON data back to a JournalEntry
            let journalEntry = try JSONDecoder().decode(JournalEntry.self, from: jsonData)
            return journalEntry
            
        } catch {
            
            print(error)
            
            return nil
            
        }
    }
    
    func deleteJournalEntry(journalEntry: JournalEntry) {
        // Remove the journal entry from the array
        if let index = journalEntries.firstIndex(where: { $0.id == journalEntry.id }) {
            journalEntries.remove(at: index)
        }
        
        let fileManager = FileManager.default
        
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        // Delete journal entry JSON file
        let fileURL = documentsDirectory.appendingPathComponent("\(journalEntry.id).json")
        do {
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("Error deleting file: \(error.localizedDescription)")
        }
        
        // Delete associated image if present
        if let imagePath = journalEntry.imagePath {
            let imageURL = URL(fileURLWithPath: imagePath)
            if fileManager.fileExists(atPath: imageURL.path) {
                do {
                    try fileManager.removeItem(at: imageURL)
                } catch {
                    print("Error deleting image file: \(error.localizedDescription)")
                }
            }
        }
        
        // Delete associated thumbnail if present
        if let thumbnailPath = journalEntry.thumbnailPath {
            let thumbnailURL = URL(fileURLWithPath: thumbnailPath)
            if fileManager.fileExists(atPath: thumbnailURL.path) {
                do {
                    try fileManager.removeItem(at: thumbnailURL)
                } catch {
                    print("Error deleting thumbnail file: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func totalWords() -> Int {
        //get total words from entries components separated by
        
        var totalWords = 0
        //set back to zero each evaluation
        
        for i in journalEntries {
            /*
            if !(i.title).isEmpty {
                let titleWords = (i.title).components(separatedBy: CharacterSet.whitespacesAndNewlines)
                let titleCount = titleWords.count
                totalWords += titleCount
            }
             */
            if !i.entry.isEmpty {
                let words = i.entry.components(separatedBy: CharacterSet.whitespacesAndNewlines)
                let wordsCount = words.count
                totalWords += wordsCount
            }
        }
        
        return totalWords
    }
    
    // Function to calculate the number of days journaled
    func numberOfDaysJournaled() -> Int {
        let calendar = Calendar.current

        // Get the unique dates without the time component
        let uniqueDays = Set(journalEntries.map {
            calendar.startOfDay(for: $0.date)
        })

        return uniqueDays.count
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getImageURL(from path: String?) -> URL? {
        guard let path, !path.isEmpty else { return nil }
        let fileManager = FileManager.default

        // 1️⃣ Absolute path (starts with "/")
        if path.hasPrefix("/") {
            let absoluteURL = URL(fileURLWithPath: path)
            if fileManager.fileExists(atPath: absoluteURL.path) {
                return absoluteURL
            }
        }

        // 2️⃣ Images directory (new entries)
        let imagesDir = JournalManager.shared.imagesDirectory()
        let imagesURL = imagesDir.appendingPathComponent((path as NSString).lastPathComponent)
        if fileManager.fileExists(atPath: imagesURL.path) {
            return imagesURL
        }

        // 3️⃣ Documents directory (old entries)
        let documentsDir = JournalManager.shared.getDocumentsDirectory()
        let docsURL = documentsDir.appendingPathComponent((path as NSString).lastPathComponent)
        if fileManager.fileExists(atPath: docsURL.path) {
            return docsURL
        }

        return nil
    }

    
}
