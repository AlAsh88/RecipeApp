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
                return "Data is invalid or malformed"
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
            
            let validRecipes = response.recipes.filter({ $0.isValid() })
            guard validRecipes.count == response.recipes.count else {
                throw RecipeMapperError.invalidData
            }
            
            return validRecipes
        } catch DecodingError.typeMismatch {
            throw RecipeMapperError.invalidData
        } catch DecodingError.keyNotFound {
            throw RecipeMapperError.invalidData
        } catch DecodingError.valueNotFound {
            throw RecipeMapperError.invalidData
        } catch DecodingError.dataCorrupted {
            throw RecipeMapperError.invalidData
        } catch {
            throw RecipeMapperError.emptyList
        }
    }
    
}
