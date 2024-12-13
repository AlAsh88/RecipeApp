//
//  RecipeAPIClient.swift
//  RecipeApp
//
//  Created by Ayesha Shaikh on 12/12/24.
//

import Foundation

class RecipeAPIService {
    static let shared = RecipeAPIService()
    var session: URLSessionProtocol = URLSession.shared
    
    func fetchRecipes() async throws -> [RecipeModel] {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
        let (data, _) = try await session.data(from: url)
        let recipeResponse = try RecipeMapper.decode(from: data)
        
        return recipeResponse
    }
}
