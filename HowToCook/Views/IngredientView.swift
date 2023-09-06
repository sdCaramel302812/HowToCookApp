//
//  IngredientView.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/27/23.
//

import UIKit

class IngredientView: UIView {
    //var ingredients: [(ingredient: IngredientModel, qty: Double)]
    var ingredientViewModel: IngredientViewModel
    var serving: Int {
        get {
            ingredientViewModel.serving
        }
        set(newValue) {
            ingredientViewModel.serving = newValue
        }
    }
    var isSwipeable: Bool {
        get {
            ingredientViewModel.isSwipeable
        }
        set(newValue) {
            ingredientViewModel.isSwipeable = newValue
        }
    }
    
    let ingredientTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var heightConstraint: NSLayoutConstraint?
    
    init(ingredientViewModel: IngredientViewModel) {
        self.ingredientViewModel = ingredientViewModel
        super.init(frame: .zero)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(ingredientTableView)
        
        ingredientTableView.delegate = ingredientViewModel
        ingredientTableView.dataSource = ingredientViewModel
        ingredientTableView.register(IngredientTableViewCell.self, forCellReuseIdentifier: ingredientViewModel.indentifier)
        ingredientTableView.register(IngredientTableHeader.self, forHeaderFooterViewReuseIdentifier: ingredientViewModel.headerIdentifier)
        
        setConstraints()
    }
    
    func setConstraints() {
        let height = ingredientViewModel.totalHeight()
        heightConstraint = heightAnchor.constraint(equalToConstant: height)
        heightConstraint!.isActive = true
        
        ingredientTableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        ingredientTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        ingredientTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        ingredientTableView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    func addIngredient(ingredient: (IngredientModel, Double)) {
        ingredientViewModel.ingredients.append(ingredient)
        reloadHeight()
    }
    
    func reloadHeight() {
        ingredientTableView.reloadData()
        
        if let constraint = heightConstraint {
            removeConstraint(constraint)
        }
        let height = ingredientViewModel.totalHeight()
        heightConstraint = heightAnchor.constraint(equalToConstant: height)
        heightConstraint!.isActive = true
    }
}
