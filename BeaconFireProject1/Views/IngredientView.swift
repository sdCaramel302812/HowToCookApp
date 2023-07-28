//
//  IngredientView.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/27/23.
//

import UIKit

class IngredientView: UIView {
    //var ingredients: [(ingredient: IngredientModel, qty: Double)]
    private let ingredientViewModel: IngredientViewModel
    
    private let ingredientTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
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
        heightAnchor.constraint(equalToConstant: height).isActive = true
        
        ingredientTableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        ingredientTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        ingredientTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        ingredientTableView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
