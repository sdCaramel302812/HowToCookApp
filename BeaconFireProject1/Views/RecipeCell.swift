//
//  RecipeTableViewCell.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/27/23.
//

import UIKit

protocol RecipeCellDelegate: AnyObject {
    func showDetail(tag: Int)
    
    func updateFavorite(tag: Int)
}

class RecipeCell: UICollectionViewCell {
    private var categoryViewModel: HomeCategoriesViewModel?
    weak var delegate: RecipeCellDelegate?
    
    private var isFavorite: Bool = false
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let detailButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let categoriesCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
        addSubview(imageView)
        addSubview(detailButton)
        addSubview(nameLabel)
        addSubview(favoriteButton)
        addSubview(categoriesCollectionView)
        
        detailButton.addTarget(self, action: #selector(detailButtonPressed), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        
        setConstraints()
    }
    
    private func setConstraints() {
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        
        detailButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        detailButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        detailButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        detailButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        favoriteButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        categoriesCollectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func configure(category viewModel: HomeCategoriesViewModel, name: String, image: UIImage?, tag: Int, isFavorite: Bool) {
        categoryViewModel = viewModel
        categoryViewModel!.isEditable = false
        categoriesCollectionView.delegate = categoryViewModel
        categoriesCollectionView.dataSource = categoryViewModel
        categoriesCollectionView.register(HomeCategoriesCell.self, forCellWithReuseIdentifier: categoryViewModel!.reuseIdentifier)
        
        nameLabel.text = name
        let croppedImage = Utils.cropImage(image, WHRatio: 1 / 0.4)
        imageView.image = croppedImage
        self.tag = tag
        
        setFavorite(isFavorite)
    }
    
    @objc private func detailButtonPressed(_ sender: UIButton) {
        delegate?.showDetail(tag: tag)
    }
    
    @objc private func favoriteButtonPressed(_ sender: UIButton) {
        delegate?.updateFavorite(tag: tag)
        setFavorite(!isFavorite)
    }
    
    private func setFavorite(_ isFavarote: Bool) {
        self.isFavorite = isFavarote
        if isFavarote {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}
