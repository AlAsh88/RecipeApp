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
        let emptyJSONList = ["recipes": []]
        let jsonData = try! JSONSerialization.data(withJSONObject: emptyJSONList, options: .prettyPrinted)
        
        XCTAssertThrowsError(try RecipeMapper.decode(from: jsonData)) { error in
            XCTAssertEqual(error as? RecipeMapper.RecipeMapperError, .emptyList, "No recipes are available")
        }
        
    }
    
    /// 2. Valid JSON Decoding
    func test_validateJSON() throws {
        // Arrange: Valid JSON
        let recipeJSON = makeRecipeItem(cuisine: "British",
                                     name: "Bakewell Tart",
                                     photoURLLarge: URL(string: "http://a-photoURLLarge-url.com")!,
                                     photoURLSmall: URL(string: "http://a-photoURLSmall-url.com")!,
                                     id: UUID(),
                                     sourceURL: URL(string: "http://a-sourceURL-url.com")!,
                                     youtubeURL: URL(string: "http://a-youtubeURL-url.com")!)
        
        let expectedRecipes = [recipeJSON.model]
        
        // Wrap the recipe JSON in a "recipes" array
        let topLevelJSON = ["recipes": [recipeJSON.json]]
        
        // Act: Convert JSON to Data
        let jsonData = try JSONSerialization.data(withJSONObject: topLevelJSON, options: .prettyPrinted)
        
        // Act: Decode JSON
        let recipes = try RecipeMapper.decode(from: jsonData)
        
        // Assert: Verify decoded models match expected models
        XCTAssertEqual(recipes, expectedRecipes)
    }
    
    
    // MARK: - Helpers
    private func makeRecipeItem(cuisine: String, name: String? = nil, photoURLLarge: URL?, photoURLSmall: URL?, id: UUID, sourceURL: URL?, youtubeURL: URL?) -> (model: RecipeModel, json: [String: Any]) {
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
    
    private func recipeRecipeJSON(_ recipes: [[String: Any]]) -> Data {
        let json = ["recipes": recipes]
        
        return try! JSONSerialization.data(withJSONObject: json)
    }

}
