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
}
