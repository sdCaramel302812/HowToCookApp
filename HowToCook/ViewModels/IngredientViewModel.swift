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
    var isSwipeable = false
    var serving: Int = 1
    var sortedIngredients: [(ingredient: IngredientModel, qty: Double)] {
        get {
            ingredients.sorted { $0.ingredient.name < $1.ingredient.name }
        }
    }
    
    private let defaults = UserDefaults.standard
    
    init(ingredients: [(ingredient: IngredientModel, qty: Double)], rowHeight: Double, indentifier: String, headerIdentifier: String) {
        self.ingredients = ingredients
        self.rowHeight = rowHeight
        self.indentifier = indentifier
        self.headerIdentifier = headerIdentifier
    }
    
    func totalHeight() -> Double {
        return rowHeight * Double(ingredients.count + 2)
    }
    
    let ozOverG = 28.3495
    let tbspOverMl = 14.7867
    
    func imperialQty(unit: String, qty: Double) -> (unit: String, qty: Double) {
        switch unit.lowercased() {
        case "g":
            return ("oz", qty / ozOverG)
        case "ml":
            return ("tbsp", qty / tbspOverMl)
        default:
            return (unit, qty)
        }
    }
    
    func metricQty(unit: String, qty: Double) -> (unit: String, qty: Double) {
        switch unit.lowercased() {
        case "oz":
            return ("g", qty * ozOverG)
        case "tbsp":
            return ("mL", qty * tbspOverMl)
        default:
            return (unit, qty)
        }
    }
}

extension IngredientViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as? IngredientTableHeader
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        isSwipeable
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete", handler: { _,_,_ in
            self.ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete", handler: { _,_,_ in
            self.ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })])
    }
}

extension IngredientViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (ingredient, qty) = sortedIngredients[indexPath.row]
        let measure = defaults.bool(forKey: "isMetric")
            ? metricQty(unit: ingredient.unit, qty: qty * Double(serving))
            : imperialQty(unit: ingredient.unit, qty: qty * Double(serving))
        guard let cell = tableView.dequeueReusableCell(withIdentifier: indentifier, for: indexPath) as? IngredientTableViewCell else {
            let newCell = IngredientTableViewCell()
            newCell.configure(image: ingredient.image, name: ingredient.name, qty: String(format: "%.2f", measure.qty), unit: measure.unit, height: rowHeight)
            return newCell
        }
        cell.configure(image: ingredient.image, name: ingredient.name, qty: String(format: "%.2f", measure.qty), unit: measure.unit, height: rowHeight)
        return cell
    }
}
