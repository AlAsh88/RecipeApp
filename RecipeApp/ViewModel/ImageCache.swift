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
    
    private let cacheDirectory: URL
    private var memoryCache: [URL: UIImage] = [:]
    
    init(session: URLSessionProtocol = URLSession.shared) {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        self.cacheDirectory = paths[0].appendingPathComponent("RecipeImageCache")
        
        self.session = session
        
        if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
            try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    func loadImage(from url: URL, session: URLSessionProtocol = URLSession.shared) async throws -> UIImage {
        if let image = memoryCache[url] {
            return image
        }
        
        let fileURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        
        if let image = UIImage(contentsOfFile: fileURL.path) {
            memoryCache[url] = image
            return image
        }
        
        do {
            let (data, _) = try await session.dataResponse(from: url)
            guard let image = UIImage(data: data) else {
                throw NSError(domain: "ImageCache", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode image data"])
            }
            
            memoryCache[url] = image
            try data.write(to: fileURL)
            
            return image
        } catch let urlError as URLError {
            throw urlError
        } catch {
            throw NSError(domain: "ImageCache", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load image: \(error.localizedDescription)"])
        }
    }
    
}
