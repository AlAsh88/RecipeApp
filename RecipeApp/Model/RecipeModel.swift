//
//  RecipeFeed.swift
//  RecipeApp
//
//  Created by Ayesha Shaikh on 12/10/24.
//

import Foundation

public struct RecipeModel: Codable, Equatable {
    public let cuisine: String
    public let name: String
    public let photoURLLarge: URL?
    public let photoURLSmall: URL?
    public let id: UUID
    public let sourceURL: URL?
    public let youtubeURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case id = "uuid"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}

extension RecipeModel {
    func isValid() -> Bool {
        return !name.isEmpty
    }
}
