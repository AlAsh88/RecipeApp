//
//  RecipeCell.swift
//  RecipeApp
//
//  Created by Ayesha Shaikh on 12/16/24.
//

import UIKit

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var cuisineType: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    func configure(with recipe: RecipeModel) {
        nameLabel?.text = recipe.name
        cuisineType?.text = recipe.cuisine
        
        recipeImageView?.image = nil
        
        if let photoURL = recipe.photoURLSmall {
            Task {
                do {
                    let image = try await ImageCache.shared.loadImage(from: photoURL)
                    await MainActor.run {
                        self.recipeImageView.image = image
                    }
                } catch {
                    print("Failed to load image: \(error.localizedDescription)")
                }
            }
        }
    }

}
