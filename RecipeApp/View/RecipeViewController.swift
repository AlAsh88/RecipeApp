//
//  ViewController.swift
//  RecipeApp
//
//  Created by Ayesha Shaikh on 12/10/24.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recipeTableView: UITableView!
    
    var recipes: [RecipeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        Task {
            await fetchRecipes()
        }
    }
    
    func fetchRecipes() async {
        do {
            recipes = try await RecipeAPIService.shared.fetchRecipes()
            await MainActor.run {
                self.recipeTableView.reloadData()
            }
        } catch {
            print("Error fetching recipes: \(error.localizedDescription)")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !recipes.isEmpty else {
            return 0
        }
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        let recipe = recipes[indexPath.row]
        print("@@@@@@ Recipe: \(recipe)")
        cell.configure(with: recipe)
        
        return cell
    }

}

