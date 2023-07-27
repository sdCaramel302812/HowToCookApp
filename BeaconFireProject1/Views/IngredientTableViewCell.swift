//
//  IngredientTableViewCell.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/27/23.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    private let ingredientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let qtyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let unitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        contentView.addSubview(ingredientImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(qtyLabel)
        contentView.addSubview(unitLabel)
        
        setConstraints()
    }
    
    private func setConstraints() {
        ingredientImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        ingredientImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35).isActive = true
        
        unitLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        unitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        qtyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        qtyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
    }
    
    func configure(image: UIImage?, name: String, qty: String, unit: String, height: Double) {
        ingredientImageView.image = Utils.resizeImage(Utils.cropImage(image, WHRatio: 1), height: height * 0.8)
        nameLabel.text = name
        qtyLabel.text = qty
        unitLabel.text = unit
    }
}
