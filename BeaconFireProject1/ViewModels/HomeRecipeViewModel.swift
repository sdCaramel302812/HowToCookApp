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
    var recipes: [RecipeModel] = []
    weak var delegate: HomeRecipeViewModelDelegate?

    let reuseIdentifier: String
    let categoryCellId = "categoryCellId"
    
    init(coreData: CoreDataStack, identifier: String) {
        self.coreData = coreData
        reuseIdentifier = identifier
        super.init()
        loadCoreData()
    }
    
    func loadCoreData() {
        let recipeRequest = Recipes.fetchRequest()
        let recipe = coreData.fetch(recipeRequest)
        guard let recipe else {
            coreData.initCoreData()
            return
        }
        self.recipes = recipeToRecipeModel(recipes: recipe)
        
    }
    
    func recipeToRecipeModel(recipes: [Recipes]) -> [RecipeModel] {
        var result: [RecipeModel] = []
        for recipe in recipes {
            let name = recipe.name ?? ""
            let image = UIImage(named: recipe.image ?? "")
            let description = recipe.descriptions ?? ""
            let instruction = recipe.instructions ?? ""
            let isFavorite = recipe.isFavorite
            var categories: [String] = []
            if let categoryRelation = recipe.isA {
                for item in categoryRelation {
                    if let cat = (item as? RecipeCategories)?.category?.name {
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
            let recipeModel = RecipeModel(name: name, image: image, description: description, instruction: instruction, categories: categories, ingredients: ingredients, isFavorite: isFavorite)
            result.append(recipeModel)
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
        recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recipe = recipes[indexPath.row]
        let viewModel = HomeCategoriesViewModel(categories: recipe.categories, identifier: categoryCellId)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RecipeCell else {
            let newCell = RecipeCell()
            newCell.configure(category: viewModel, name: recipe.name, image: recipe.image, tag: indexPath.row, isFavorite: recipe.isFavorite)
            newCell.delegate = self
            return newCell
        }
        cell.configure(category: viewModel, name: recipe.name, image: recipe.image, tag: indexPath.row, isFavorite: recipe.isFavorite)
        cell.delegate = self
        return cell
    }
}

extension HomeRecipeViewModel: RecipeCellDelegate {
    func showDetail(tag: Int) {
        delegate?.showDetail(recipe: recipes[tag], tag: tag)
    }
    
    func updateFavorite(tag: Int) {
        recipes[tag].isFavorite = !recipes[tag].isFavorite
    }
}
