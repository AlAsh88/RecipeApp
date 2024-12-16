//
//  ImageCache.swift
//  RecipeApp
//
//  Created by Ayesha Shaikh on 12/13/24.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    var session: URLSessionProtocol
    
    let cacheDirectory: URL
    var memoryCache: [URL: UIImage] = [:]
    
    // A serial queue for thread-safe access to the memory cache
    private let cacheQueue = DispatchQueue(label: "com.yourapp.cacheQueue")
    
    init(session: URLSessionProtocol = URLSession.shared) {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        self.cacheDirectory = paths[0].appendingPathComponent("RecipeImageCache")
        
        self.session = session
        
        if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
            do {
                try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
                print("!!!! Cache directory created at: \(cacheDirectory.path)")
            } catch {
                print("!!!! Failed to create cache directory: \(error.localizedDescription)")
            }
        }
    }
    
    // Retrieve image from memory cache
    func retrieveImage(fromCache url: URL) -> UIImage? {
        return memoryCache[url] // Check if image is in memory cache
    }
    
    func loadImage(from url: URL, session: URLSessionProtocol = URLSession.shared) async throws -> UIImage {
        // Check if the image is in memory cache
        if let cachedImage = memoryCache[url] {
            return cachedImage
        }
        
        // If not in memory cache, load the image from disk or network
        // (Your existing image loading logic)
        let fileURL = getFileURL(for: url)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            // Load from disk
            if let image = UIImage(contentsOfFile: fileURL.path) {
                self.addImageToCache(image: image, url: url)
                return image
            }
        }
        
        // If not found in cache or disk, download from network
        let (data, _) = try await session.dataResponse(from: url)
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "ImageCache", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode image"])
        }
        
        // Add image to cache after downloading
        self.addImageToCache(image: image, url: url)
        
        // Optionally write to disk
        try data.write(to: fileURL)
        
        return image
    }
    
    // Function to add an image to the memory cache safely
    private func addImageToCache(image: UIImage, url: URL) {
        // Use a serial queue to ensure thread safety when modifying the cache
        cacheQueue.async {
            self.memoryCache[url] = image
            print("!!!! Image added to memory cache with key: \(url)")
        }
    }
    
    // Helper function to get file URL for disk cache
    private func getFileURL(for url: URL) -> URL {
        // Generate a unique file name using the absoluteString or a hash of the URL
        let urlString = url.absoluteString
        let hashedURLString = String(urlString.hashValue) // Create a hash of the URL string
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return cacheDirectory.appendingPathComponent("\(hashedURLString).jpg") // Use the hashed URL string as the file name
    }
    
}

extension ImageCache {
    func reset() {
        memoryCache.removeAll()
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: cacheDirectory)
    }
}

