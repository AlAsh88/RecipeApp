//
//  RecipeImageCacheTests.swift
//  RecipeAppTests
//
//  Created by Ayesha Shaikh on 12/13/24.
//

import XCTest
@testable import RecipeApp

class RecipeImageCacheTests: XCTestCase {
    
    /// 1. Network connectivity error
    func test_loadImageConnectivityError() async {
        let cacheReset = ImageCache()
        cacheReset.reset()
        
        let mockImageURL = URL(string: "https://mockimage.com/image.jpg")!
        let mockImageData = Data()
        let mockImageResponse = HTTPURLResponse(url: mockImageURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let mockSession = MockURLSession(data: mockImageData, response: mockImageResponse, error: nil, simulateConnectivityError: true)
        
        let originalSession = ImageCache.shared.session
        ImageCache.shared.session = mockSession
         
        defer {
            ImageCache.shared.session = originalSession
        }
        
        do {
            _ = try await ImageCache.shared.loadImage(from: mockImageURL, session: mockSession)
            XCTFail("Expected to throw a connectivity error, but no error was thrown")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .notConnectedToInternet, "Unexpected error code: \(error.code)")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_memoryCacheStoresAndRetrievesImage() {
        let mockImageURL = URL(string: "https://example.com/image.jpg")!
        let mockImage = UIImage(systemName: "star.fill")!
        
        ImageCache.shared.memoryCache[mockImageURL] = mockImage
        
        let cachedImage = ImageCache.shared.memoryCache[mockImageURL]
        XCTAssertEqual(mockImage, cachedImage, "The memory cache should store and retrieve the same image.")
    }
    
    func test_fetchImageFromCache() async throws {
        let testRecipe = RecipeModel(
            cuisine: "Italian",
            name: "Margherita Pizza",
            photoURLLarge: URL(string: "https://www.w3schools.com/w3images/pizza.jpg"),
            photoURLSmall: URL(string: "https://www.w3schools.com/w3images/pizza.jpg"),
            id: UUID(),
            sourceURL: URL(string: "https://www.w3schools.com"),
            youtubeURL: URL(string: "https://youtube.com")
        )

        guard let photoURL = testRecipe.photoURLSmall else {
            XCTFail("Failed to retrieve photo URL from test recipe.")
            return
        }

        let mockImageData = try Data(contentsOf: photoURL)
        let mockResponse = HTTPURLResponse(url: photoURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockSession = MockURLSession(data: mockImageData, response: mockResponse, error: nil)

        let originalSession = ImageCache.shared.session
        ImageCache.shared.session = mockSession
        defer { ImageCache.shared.session = originalSession }

        let fetchedImage = try await ImageCache.shared.loadImage(from: photoURL, session: mockSession)

        XCTAssertNotNil(ImageCache.shared.memoryCache[photoURL], "Memory cache should contain the fetched image.")

        let fileURL = ImageCache.shared.cacheDirectory.appendingPathComponent(photoURL.lastPathComponent)
        let fileManager = FileManager.default
        XCTAssertTrue(fileManager.fileExists(atPath: fileURL.path), "Disk cache should contain the fetched image.")

        if let cachedData = try? Data(contentsOf: fileURL), let cachedImage = UIImage(data: cachedData) {
            XCTAssertEqual(cachedImage.size, fetchedImage.size, "The cached image size should match the fetched image size.")
        }
    }
    
    func test_cacheMiss_fetchImageFromNetwork() async throws {
        let testRecipe = RecipeModel(
            cuisine: "Italian",
            name: "Margherita Pizza",
            photoURLLarge: URL(string: "https://www.w3schools.com/w3images/pizza.jpg"),
            photoURLSmall: URL(string: "https://www.w3schools.com/w3images/pizza.jpg"),
            id: UUID(),
            sourceURL: URL(string: "https://www.w3schools.com"),
            youtubeURL: URL(string: "https://youtube.com")
        )
        
        guard let photoURL = testRecipe.photoURLSmall else {
            XCTFail("Failed to retrieve photo URL from test recipe.")
            return
        }

        let mockImageData = try Data(contentsOf: photoURL)
        let mockResponse = HTTPURLResponse(url: photoURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockSession = MockURLSession(data: mockImageData, response: mockResponse, error: nil)

        let originalSession = ImageCache.shared.session
        ImageCache.shared.session = mockSession
        defer { ImageCache.shared.session = originalSession }

        XCTAssertNil(ImageCache.shared.memoryCache[photoURL], "Image should not be in memory cache before fetching.")

        _ = try await ImageCache.shared.loadImage(from: photoURL, session: mockSession)
        
        // Assert: Verify the image is now in memory cache and saved to disk
        XCTAssertNotNil(ImageCache.shared.memoryCache[photoURL], "Memory cache should contain the image after fetch.")
        let fileURL = ImageCache.shared.cacheDirectory.appendingPathComponent(photoURL.lastPathComponent)
        XCTAssertTrue(FileManager.default.fileExists(atPath: fileURL.path), "Disk cache should contain the image after fetch.")
    }





}
