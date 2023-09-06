//
//  RecipeModel.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/26/23.
//

import Foundation
import UIKit

struct RecipeModel {
    var name: String
    var image: UIImage?
    var description: String
    var instruction: String
    var categories: [String]
    var ingredients: [(ingredient: IngredientModel, qty: Double)]
    var isFavorite: Bool = false
    var tag: Int = 0
    var coreDataRef: Recipes?
    
    func updateRef(coreData: CoreDataStack) {
        guard let ref = coreDataRef else {
            return
        }
        ref.name = name
        ref.descriptions = description
        ref.instructions = instruction
        ref.isFavorite = isFavorite
        
        updateRefCategory(coreData: coreData, ref: ref)
        updateRefIngredient(coreData: coreData, ref: ref)
    }
    
    private func updateRefCategory(coreData: CoreDataStack, ref: Recipes) {
        guard let refCategories = ref.isA else {
            return
        }
        for category in refCategories {
            if let cat = category as? Categories {
                ref.removeFromIsA(cat)
                cat.removeFromHasRecipes(ref)
            }
        }
        let categoryRequest = Categories.fetchRequest()
        let categoriesRefs = coreData.fetch(categoryRequest)
        guard let categoriesRefs else {
            return
        }
        for category in categoriesRefs {
            if categories.contains(category.name ?? "") {
                category.addToHasRecipes(ref)
                ref.addToIsA(category)
            }
        }
    }
    
    private func updateRefIngredient(coreData: CoreDataStack, ref: Recipes) {
        guard let refIngredients = ref.uses else {
            return
        }
        for ingredient in refIngredients {
            if let ing = ingredient as? RecipeIngredients {
                ref.removeFromUses(ing)
                coreData.persistentContainer.viewContext.delete(ing)
            }
        }
        let ingredientRequest = Ingredients.fetchRequest()
        let ingredientRefs = coreData.fetch(ingredientRequest)
        guard let ingredientRefs else {
            return
        }
        for ingredient in ingredientRefs {
            for (model, qty) in ingredients {
                if model.name != ingredient.name {
                    continue
                }
                let recipeIng = RecipeIngredients(context: coreData.persistentContainer.viewContext)
                recipeIng.recipe = ref
                recipeIng.ingredient = ingredient
                recipeIng.quantity = qty
                ref.addToUses(recipeIng)
                ingredient.addToUsedBy(recipeIng)
            }
        }
    }
}
