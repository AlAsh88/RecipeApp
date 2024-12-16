//
//  ViewController.swift
//  RecipeApp
//
//  Created by Ayesha Shaikh on 12/10/24.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var recipeTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    var recipes: [RecipeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        
        recipeTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshRecipes), for: .valueChanged)
        
        Task {
            await fetchRecipes()
        }
    }
    
    @objc private func refreshRecipes() {
        Task {
            await fetchRecipes()
            refreshControl.endRefreshing()
        }
    }
    
   
    @IBAction func sortButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Sort Recipes", message: "Choose sorting option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "By Name", style: .default) { _ in
            self.recipes.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            self.recipeTableView.reloadData()
        })
        
        alert.addAction(UIAlertAction(title: "By Cuisine", style: .default) { _ in
            self.recipes.sort { $0.cuisine.localizedCaseInsensitiveCompare($1.cuisine) == .orderedAscending }
            self.recipeTableView.reloadData()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    func fetchRecipes() async {
        do {
            recipes = try await RecipeAPIService.shared.fetchRecipes()
            await MainActor.run {
                self.recipeTableView.reloadData()
            }
        } catch {
            await MainActor.run {
                self.refreshControl.endRefreshing()
            }
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
        cell.configure(with: recipe)
        
        return cell
    }
    
}
