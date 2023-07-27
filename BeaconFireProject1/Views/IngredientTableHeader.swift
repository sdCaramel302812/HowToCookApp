//
//  IngredientTableHeader.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/27/23.
//

import UIKit

class IngredientTableHeader: UITableViewHeaderFooterView {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let qtyLabel: UILabel = {
        let label = UILabel()
        label.text = "Qty"
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let unitLabel: UILabel = {
        let label = UILabel()
        label.text = "Unit"
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(qtyLabel)
        contentView.addSubview(unitLabel)
        
        setConstraints()
    }
    
    private func setConstraints() {
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35).isActive = true
        
        unitLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        unitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        qtyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        qtyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
    }
}
