//
//  HomeRecipeViewModel.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/27/23.
//

import Foundation
import UIKit

protocol HomeRecipeViewModelDelegate: AnyObject {
    func showDetail(recipe: RecipeModel, tag: Int)
}

class HomeRecipeViewModel: NSObject {
    private var coreData: CoreDataStack
    var recipes: [Int: RecipeModel] = [:]
    weak var delegate: HomeRecipeViewModelDelegate?
    
    var selectedCategories: [String] = []
    var filteredRecipes: [RecipeModel] {
        get {
            if selectedCategories.count == 0 {
                return isAcending
                    ? Array(recipes.values).sorted { $0.name > $1.name }
                    : Array(recipes.values).sorted { $0.name < $1.name }
            }
            let filtered = recipes.values.filter {
                for category in selectedCategories {
                    if !$0.categories.contains(category) {
                        return false
                    }
                }
                return true
            }
            return isAcending
                ? filtered.sorted { $0.name > $1.name }
                : filtered.sorted { $0.name < $1.name }
        }
    }
    var isAcending = false

    let reuseIdentifier: String
    let categoryCellId = "categoryCellId"
    
    init(coreData: CoreDataStack, identifier: String) {
        self.coreData = coreData
        reuseIdentifier = identifier
        super.init()
        loadCoreData()
    }
    
    func loadCoreData() {
        coreData.removeDuplicatedIngredients()
        
        let recipeRequest = Recipes.fetchRequest()
        let recipe = coreData.fetch(recipeRequest)
        guard let recipe else {
            coreData.initCoreData()
            return
        }
        self.recipes = recipeToRecipeModel(recipes: recipe)
    }
    
    func recipeToRecipeModel(recipes: [Recipes]) -> [Int: RecipeModel] {
        var result: [Int: RecipeModel] = [:]
        for i in 0..<recipes.count {
            let recipe = recipes[i]
            let name = recipe.name ?? ""
            let image = UIImage(named: recipe.image ?? "")
            let description = recipe.descriptions ?? ""
            let instruction = recipe.instructions ?? ""
            let isFavorite = recipe.isFavorite
            var categories: [String] = []
            if let categoryRelation = recipe.isA {
                for item in categoryRelation {
                    if let cat = (item as? Categories)?.name {
                        categories.append(cat)
                    }
                }
            }
            categories.sort()
            var ingredients: [(ingredient: IngredientModel, qty: Double)] = []
            if let ingredientRelation = recipe.uses {
                for item in ingredientRelation {
                    if let ing = (item as? RecipeIngredients)?.ingredient,
                       let qty = (item as? RecipeIngredients)?.quantity {
                        ingredients.append((ingredientToIngredientModel(ingredient: ing), qty))
                    }
                }
            }
            ingredients.sort { $0.ingredient.name < $1.ingredient.name }
            let recipeModel = RecipeModel(name: name, image: image, description: description, instruction: instruction, categories: categories, ingredients: ingredients, isFavorite: isFavorite, tag: i, coreDataRef: recipe)
            result[i] = recipeModel
        }
        return result
    }
    
    func ingredientToIngredientModel(ingredient: Ingredients) -> IngredientModel {
        return IngredientModel(
            name: ingredient.name ?? "",
            image: UIImage(named: ingredient.image ?? ""),
            unit: ingredient.unit ?? "")
    }
}

extension HomeRecipeViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: width * 0.65)
    }
}

extension HomeRecipeViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recipe = filteredRecipes[indexPath.row]
        let viewModel = HomeCategoriesViewModel(categories: recipe.categories, identifier: categoryCellId)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RecipeCell else {
            let newCell = RecipeCell()
            newCell.configure(category: viewModel, name: recipe.name, image: recipe.image, tag: recipe.tag, isFavorite: recipe.isFavorite)
            newCell.delegate = self
            return newCell
        }
        cell.configure(category: viewModel, name: recipe.name, image: recipe.image, tag: recipe.tag, isFavorite: recipe.isFavorite)
        cell.delegate = self
        return cell
    }
}

extension HomeRecipeViewModel: RecipeCellDelegate {
    func showDetail(tag: Int) {
        guard let recipe = recipes[tag] else {
            return
        }
        delegate?.showDetail(recipe: recipe, tag: tag)
    }
    
    func updateFavorite(tag: Int) {
        guard let recipe = recipes[tag] else {
            return
        }
        recipes[tag]?.isFavorite = !recipe.isFavorite
    }
}
