//
//  IngredientViewModel.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/27/23.
//

import Foundation
import UIKit

class IngredientViewModel: NSObject {
    var ingredients: [(ingredient: IngredientModel, qty: Double)]
    var rowHeight: Double
    let indentifier: String
    let headerIdentifier: String
    
    init(ingredients: [(ingredient: IngredientModel, qty: Double)], rowHeight: Double, indentifier: String, headerIdentifier: String) {
        self.ingredients = ingredients
        self.rowHeight = rowHeight
        self.indentifier = indentifier
        self.headerIdentifier = headerIdentifier
    }
    
    func totalHeight() -> Double {
        return rowHeight * Double(ingredients.count + 2)
    }
}

extension IngredientViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as? IngredientTableHeader
    }
}

extension IngredientViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: indentifier, for: indexPath) as? IngredientTableViewCell else {
            return IngredientTableViewCell()
        }
        let (ingredient, qty) = ingredients[indexPath.row]
        cell.configure(image: ingredient.image, name: ingredient.name, qty: String(qty), unit: ingredient.unit, height: rowHeight)
        return cell
    }
}
