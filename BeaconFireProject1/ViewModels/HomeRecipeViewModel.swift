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
    var recipes: [RecipeModel]
    weak var delegate: HomeRecipeViewModelDelegate?

    let reuseIdentifier: String
    let categoryCellId = "categoryCellId"
    
    init(recipes: [RecipeModel], identifier: String) {
        self.recipes = recipes
        reuseIdentifier = identifier
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
