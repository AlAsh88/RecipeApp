//
//  RecipeMapper.swift
//  RecipeApp
//
//  Created by Ayesha Shaikh on 12/10/24.
//

import Foundation

class RecipeMapper {
    struct RecipeResponse: Decodable {
        let recipes: [RecipeModel]
    }
    
    enum RecipeMapperError: Error, LocalizedError {
        case invalidData
        case emptyList
        
        var errorDescription: String? {
            switch self {
            case .invalidData:
                return "Data is invalid or malformed."
            case .emptyList:
                return "No recipes are available"
            }
        }
    }
    
    static func decode(from jsonDATA: Data) throws -> [RecipeModel] {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(RecipeResponse.self, from: jsonDATA)
            guard !response.recipes.isEmpty else {
                throw RecipeMapperError.emptyList
            }
            return response.recipes
            
        } catch _ as DecodingError {
            throw RecipeMapperError.invalidData
        } catch {
            throw RecipeMapperError.emptyList
        }
    }
    
}
