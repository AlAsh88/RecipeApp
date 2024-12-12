//
//  RecipeAppTests.swift
//  RecipeAppTests
//
//  Created by Ayesha Shaikh on 12/10/24.
//

import XCTest
@testable import RecipeApp

final class RecipeAppTests: XCTestCase {

    // MARK: - Tests
    /// 1. Empty JSON
    func test_emptyJSON() {
        let jsonData = serializeRecipeJSON([])
        
        XCTAssertThrowsError(try RecipeMapper.decode(from: jsonData)) { error in
            XCTAssertEqual(error as? RecipeMapper.RecipeMapperError, .emptyList, "No recipes are available")
        }
    }
    
    /// 2. Invalid JSON
    func test_invalidJSON() {
        let invalidJSON = ["recipes": [
            "cuisine": "British",
            "name": "Apple Frangipan Tart",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/small.jpg",
            "uuid": "74f6d4eb-da50-4901-94d1-deae2d8af1d1",
            "youtube_url": "https://www.youtube.com/watch?v=rp8Slv4INLk"
            
        ]]
        let jsonData = serializeRecipeJSON([invalidJSON])
        
        XCTAssertThrowsError(try RecipeMapper.decode(from: jsonData)) { error in
            XCTAssertEqual(error as? RecipeMapper.RecipeMapperError, .invalidData, "Data is invalid or malformed")
        }
    }
    
    /// 3. Malformed JSON
    func test_malformedJSON_throwsInvalidDataErrorForMissingRequiredFields() {
        let malformedJSON: [String: Any] = ["recipes": [
            [
                "cuisine": "British",
                "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
                
            ],
            [
                "cuisine": "British",
                "name": "Apple Frangipan Tart",
                "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg",
                "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/small.jpg",
                "uuid": "74f6d4eb-da50-4901-94d1-deae2d8af1d1",
                "youtube_url": "https://www.youtube.com/watch?v=rp8Slv4INLk"
            ],
            [
                "cuisine": "Canadian",
                "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/f18384e7-3da7-4714-8f09-bbfa0d2c8913/large.jpg",
                "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/f18384e7-3da7-4714-8f09-bbfa0d2c8913/small.jpg",
                "source_url": "https://www.bbcgoodfood.com/recipes/1837/canadian-butter-tarts",
                "uuid": "39ad8233-c470-4394-b65f-2a6c3218b935"
            ]
        ]
        ]
        
        let jsonData = serializeRecipeJSON([malformedJSON])
        
        XCTAssertThrowsError(try RecipeMapper.decode(from: jsonData)) { error in
            XCTAssertEqual(error as? RecipeMapper.RecipeMapperError, .invalidData, "JSON data is malformed")
        }
    }
    
    /// 4. Valid JSON Decoding
    func test_validateJSON() throws {
        let recipeJSON = makeRecipeItem(cuisine: "British",
                                     name: "Bakewell Tart",
                                     photoURLLarge: URL(string: "http://a-photoURLLarge-url.com")!,
                                     photoURLSmall: URL(string: "http://a-photoURLSmall-url.com")!,
                                     id: UUID(),
                                     sourceURL: URL(string: "http://a-sourceURL-url.com")!,
                                     youtubeURL: URL(string: "http://a-youtubeURL-url.com")!)
        
        let expectedRecipes = [recipeJSON.model]
        let jsonData = serializeRecipeJSON([recipeJSON.json])
        
        let recipes = try RecipeMapper.decode(from: jsonData)
        
        XCTAssertEqual(recipes, expectedRecipes)
    }
    
    
    // MARK: - Helpers
    private func makeRecipeItem(cuisine: String, name: String? = nil, photoURLLarge: URL? = nil, photoURLSmall: URL? = nil, id: UUID, sourceURL: URL? = nil, youtubeURL: URL? = nil) -> (model: RecipeModel, json: [String: Any]) {
        let recipe = RecipeModel(cuisine: cuisine,
                                 name: name!,
                                 photoURLLarge: photoURLLarge,
                                 photoURLSmall: photoURLSmall,
                                 id: id, sourceURL: sourceURL,
                                 youtubeURL: youtubeURL)
        
        let json: [String: Any] = [
            "cuisine": cuisine,
            "name": name,
            "photo_url_large": photoURLLarge?.absoluteString,
            "photo_url_small": photoURLSmall?.absoluteString,
            "uuid": id.uuidString,
            "source_url": sourceURL?.absoluteString,
            "youtube_url": youtubeURL?.absoluteString
        ].compactMapValues { $0 }
        
        return (recipe, json)
    }
    
    private func serializeRecipeJSON(_ recipes: [[String: Any]]) -> Data {
        let json = ["recipes": recipes]
        
        return try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    }

}
