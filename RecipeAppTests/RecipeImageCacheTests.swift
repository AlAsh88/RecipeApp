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

}
