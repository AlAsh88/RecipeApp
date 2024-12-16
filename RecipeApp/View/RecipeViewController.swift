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
        
//        print(recipeTableView == nil ? "!!!! TableView is nil" : "!!!! TableView is connected")

    }
    
    func fetchRecipes() async {
        do {
            recipes = try await RecipeAPIService.shared.fetchRecipes()
            await MainActor.run {
                recipeTableView.reloadData()
            }
        } catch {
            // Handle error (e.g., show an alert)
            print("Error fetching recipes: \(error.localizedDescription)")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("!!!! Dequeueing cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        let recipe = recipes[indexPath.row]
        cell.configure(with: recipe)
//        print(type(of: cell)) // Should print "RecipeCell"

        
        return cell
    }

}

