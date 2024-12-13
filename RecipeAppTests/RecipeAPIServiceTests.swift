//
//  RecipeAPITests.swift
//  RecipeAppTests
//
//  Created by Ayesha Shaikh on 12/12/24.
//

import XCTest
@testable import RecipeApp

class RecipeAPIServiceTests: XCTestCase {
    
    /// 1. Fetch empty list
    func test_fetchRecipes_emptyJSONList() async {
        let mockSession = MockURLSession(data: MockData.emptyJSON(), response: nil, error: nil)
        RecipeAPIService.shared.session = mockSession
        
        do {
            _ = try await RecipeAPIService.shared.fetchRecipes()
            XCTFail("Expected to throw error but succeeded")
        } catch let error as RecipeMapper.RecipeMapperError {
            XCTAssertEqual(error, .emptyList)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    /// 2. Fetch recipes with incorrect format
    func test_fetchRecipes_incorrectJSONFormat() async {
        let mockSession = MockURLSession(data: MockData.invalidJSON(), response: nil, error: nil)
        RecipeAPIService.shared.session = mockSession
        
        do {
            _ = try await RecipeAPIService.shared.fetchRecipes()
            XCTFail("Expected to throw error but succeeded")
        } catch let error as RecipeMapper.RecipeMapperError {
            XCTAssertEqual(error, .invalidData)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    /// 3. Fetch recipes with malformed format
    func test_fetchRecipes_malformedJSONFormat() async {
        let mockSession = MockURLSession(data: MockData.malformedJSON(), response: nil, error: nil)
        RecipeAPIService.shared.session = mockSession
        
        do {
            _ = try await RecipeAPIService.shared.fetchRecipes()
            XCTFail("Expected to throw error but succeeded")
        } catch let error as RecipeMapper.RecipeMapperError {
            XCTAssertEqual(error, .invalidData)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    /// 4. Fetch recipes with valid JSON
    func test_fetchRecipes_validJSON() async {
        do {
            let singleSession = MockURLSession(data: MockData.validRecipesJSON(with: 1), response: nil, error: nil)
            RecipeAPIService.shared.session = singleSession
            let recipeOne = try await RecipeAPIService.shared.fetchRecipes()
            XCTAssertEqual(recipeOne.count, 1)
            XCTAssertEqual(recipeOne.first?.name, "Recipe 1")
            
            let largeSession = MockURLSession(data: MockData.validRecipesJSON(with: 1000), response: nil, error: nil)
            RecipeAPIService.shared.session = largeSession
            let recipes = try await RecipeAPIService.shared.fetchRecipes()
            XCTAssertEqual(recipes.count, 1000)
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
}
