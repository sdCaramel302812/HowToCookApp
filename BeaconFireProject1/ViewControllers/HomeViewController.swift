//
//  HomeViewController.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/26/23.
//

import UIKit

class HomeViewController: UIViewController {
    private var _username = ""
    var username: String {
        get {
            return _username
        }
        set(newValue) {
            _username = newValue
            welcomeLabel.text = "Welcome \(newValue)!"
        }
    }
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome "
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoriesCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var categoriesViewModel: HomeCategoriesViewModel!
    let categoriesCellIdentifier = "categoriesCell"
    
    private let recipeCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var recipeViewModel: HomeRecipeViewModel!
    let recipeCellIdentifier = "recipeCell"
    
    private let addRecipeButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(hierarchicalColor: .white)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor(red: 10 / 255, green: 95 / 255, blue: 255 / 255, alpha: 0.7)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let coreStack = AppDelegate.sharedCoreData
        
        categoriesViewModel = HomeCategoriesViewModel(coreData: coreStack, identifier: categoriesCellIdentifier)
        categoriesViewModel.delegate = self
        categoriesCollectionView.delegate = categoriesViewModel
        categoriesCollectionView.dataSource = categoriesViewModel
        categoriesCollectionView.register(HomeCategoriesCell.self, forCellWithReuseIdentifier: categoriesCellIdentifier)
        
        recipeViewModel = HomeRecipeViewModel(coreData: coreStack, identifier: recipeCellIdentifier)
        recipeViewModel.delegate = self
        recipeCollectionView.delegate = recipeViewModel
        recipeCollectionView.dataSource = recipeViewModel
        recipeCollectionView.register(RecipeCell.self, forCellWithReuseIdentifier: recipeCellIdentifier)
        
        view.addSubview(welcomeLabel)
        view.addSubview(categoriesCollectionView)
        view.addSubview(recipeCollectionView)
        view.addSubview(addRecipeButton)
        
        addRecipeButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        welcomeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        categoriesCollectionView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        categoriesCollectionView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        recipeCollectionView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 20).isActive = true
        recipeCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recipeCollectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        recipeCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        addRecipeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40).isActive = true
        addRecipeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        addRecipeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addRecipeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func addButtonPressed(_ sender: UIButton) {
        let emptyRecipe = RecipeModel(name: "", description: "", instruction: "", categories: [], ingredients: [])
        let vc = EditRecipeViewController(recipe: emptyRecipe, title: "Add Recipe")
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: HomeRecipeViewModelDelegate {
    func showDetail(recipe: RecipeModel, tag: Int) {
        let vc = RecipeDetailViewController(recipe: recipe, tag: tag)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: RecipeDetailViewControllerDelegate {
    func updateRecipe(recipe: RecipeModel, tag:  Int) {
        recipeViewModel.recipes[tag] = recipe
        recipeCollectionView.reloadData()
    }
}

extension HomeViewController: HomeCategoriesViewModelDelegate {
    func categorySelected(selected: [String]) {
        recipeViewModel.selectedCategories = selected
        recipeCollectionView.reloadData()
    }
}
