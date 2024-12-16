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
    
    private let cacheQueue = DispatchQueue(label: "com.yourapp.cacheQueue")
    
    init(session: URLSessionProtocol = URLSession.shared) {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        self.cacheDirectory = paths[0].appendingPathComponent("RecipeImageCache")
        
        self.session = session
        
        if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
            try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
            print("!!!! Cache directory created at: \(cacheDirectory.path)")
            
        }
    }
    
    func loadImage(from url: URL, session: URLSessionProtocol = URLSession.shared) async throws -> UIImage {
        if let cachedImage = memoryCache[url] {
            return cachedImage
        }
       
        let fileURL = getFileURL(for: url)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            if let image = UIImage(contentsOfFile: fileURL.path) {
                self.addImageToCache(image: image, url: url)
                return image
            }
        }
       
        let (data, _) = try await session.dataResponse(from: url)
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "ImageCache", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode image"])
        }
        
        self.addImageToCache(image: image, url: url)
        try data.write(to: fileURL)
        
        return image
    }
    
    private func addImageToCache(image: UIImage, url: URL) {
        cacheQueue.async {
            self.memoryCache[url] = image
            print("!!!! Image added to memory cache with key: \(url)")
        }
    }
    
    private func getFileURL(for url: URL) -> URL {
        let urlString = url.absoluteString
        let hashedURLString = String(urlString.hashValue)
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return cacheDirectory.appendingPathComponent("\(hashedURLString).jpg")
    }
    
}

extension ImageCache {
    func reset() {
        memoryCache.removeAll()
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: cacheDirectory)
    }
}

