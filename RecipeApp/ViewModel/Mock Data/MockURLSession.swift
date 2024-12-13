//
//  MockURLSession.swift
//  RecipeApp
//
//  Created by Ayesha Shaikh on 12/12/24.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        return try await data(from: url, delegate: nil)
    }
}

class MockURLSession: URLSessionProtocol {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        
        guard let data = data else {
            throw URLError(.badServerResponse)
        }
        
        return (data, response ?? URLResponse())
    }
    
}

struct MockData {
    static func validRecipesJSON(with recipeCount: Int) -> Data {
        var recipes = [[String: Any]]()
        
        for index in 1...recipeCount {
            let recipe = [
                "cuisine": "Cuisine \(index)",
                "name": "Recipe \(index)",
                "photo_url_large": "http://photoURLLarge-\(index).com",
                "photo_url_small": "http://photoURLSmall-\(index).com",
                "uuid": UUID().uuidString,
                "source_url": "http://sourceURL-\(index).com",
                "youtube_url": "http://youtubeURL-\(index).com"
            ]
            recipes.append(recipe)
        }
        let json = ["recipes": recipes]
        return try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    }
    
    static func malformedJSON() -> Data {
           """
           {
               "recipes": [
                   {
                       "cuisine": "British",
                       "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                       "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                       "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                       "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                       "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
                   },
                   {
                       "cuisine": "British",
                       "name": "Apple Frangipan Tart",
                       "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg",
                       "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/small.jpg",
                       "uuid": "74f6d4eb-da50-4901-94d1-deae2d8af1d1",
                       "youtube_url": "https://www.youtube.com/watch?v=rp8Slv4INLk"
                   }
               ]
           }
           """.data(using: .utf8)!
       }
       
       static func invalidJSON() -> Data {
           """
           {
               "recipes": [
                   {
                       "cuisine": "British",
                       "name": "Apple Frangipan Tart",
                       "photo_url_large": "https:invalid-url",
                       "photo_url_small": ,
                       "uuid": "74f6d4eb-da50-4901-94d1-deae2d8af1d1",
                       "youtube_url": "https://www.youtube.com/watch?v=rp8Slv4INLk"
                   }
               ]
           }
           """.data(using: .utf8)!
       }
    
    static func emptyJSON() -> Data {
        """
        {
            "recipes": []
        }
        """.data(using: .utf8)!
    }
    
}
