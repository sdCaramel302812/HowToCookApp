//
//  EditRecipeViewController.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/26/23.
//

import UIKit

protocol EditRecipeViewControllerDelegate: AnyObject {
    func saveRecipe(recipe: RecipeModel)
}

class EditRecipeViewController: UIViewController {
    private var recipe: RecipeModel
    weak var delegate: EditRecipeViewControllerDelegate?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit Recipe"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recipeNameInput = InputTextView(labelText: "Recipe Name")
    
    private let nameLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "limit"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionInput = InputTextView(labelText: "Description")
    
    private let descriptionLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "limit"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
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
    
    private let addCategoryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .lightGray
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipe Ingredients"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addIngredientButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .lightGray
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let ingredientView: IngredientView
    private let ingredientRowHeight = 30.0
    private let ingredientTableCellId = "ingredientTableCell"
    private let ingredientTableHeaderId = "ingredientTableHeader"
    
    private let instructionInput = InputTextView(labelText: "Instruction")
    
    
    init(recipe: RecipeModel, title: String) {
        self.recipe = recipe
        recipeNameInput.inputText = recipe.name
        descriptionInput.inputText = recipe.description
        instructionInput.inputText = recipe.instruction
        
        recipeNameInput.tag = 1
        descriptionInput.tag = 2
        nameLimitLabel.text = "limit: \(recipe.name.count)/50"
        descriptionLimitLabel.text = "limit: \(recipe.description.count)/250"
        
        let ingredientViewModel = IngredientViewModel(
            ingredients: recipe.ingredients,
            rowHeight: ingredientRowHeight,
            indentifier: ingredientTableCellId,
            headerIdentifier: ingredientTableHeaderId)
        ingredientView = IngredientView(ingredientViewModel: ingredientViewModel)
        
        titleLabel.text = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed)), animated: true)
        
        let coreStack = AppDelegate.sharedCoreData
        
        categoriesViewModel = HomeCategoriesViewModel(coreData: coreStack, identifier: categoriesCellIdentifier)
        categoriesViewModel.delegate = self
        categoriesViewModel.selectedCategories = recipe.categories
        categoriesCollectionView.delegate = categoriesViewModel
        categoriesCollectionView.dataSource = categoriesViewModel
        categoriesCollectionView.register(HomeCategoriesCell.self, forCellWithReuseIdentifier: categoriesCellIdentifier)
        
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(recipeNameInput)
        scrollView.addSubview(nameLimitLabel)
        scrollView.addSubview(descriptionInput)
        scrollView.addSubview(descriptionLimitLabel)
        scrollView.addSubview(categoryLabel)
        scrollView.addSubview(addCategoryButton)
        scrollView.addSubview(categoriesCollectionView)
        scrollView.addSubview(ingredientsLabel)
        scrollView.addSubview(addIngredientButton)
        scrollView.addSubview(ingredientView)
        scrollView.addSubview(instructionInput)
        
        addIngredientButton.addTarget(self, action: #selector(addIngredientButtonPressed), for: .touchUpInside)
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonPressed), for: .touchUpInside)
        
        recipeNameInput.delegate = self
        descriptionInput.delegate = self
        recipeNameInput.inputLimit = 50
        descriptionInput.inputLimit = 250
        if recipeNameInput.inputText.count >= 50 {
            nameLimitLabel.textColor = .red
        }
        if descriptionInput.inputText.count >= 250 {
            descriptionLimitLabel.textColor = .red
        }
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.contentSize = view.frame.size
        
        titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        
        recipeNameInput.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        recipeNameInput.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
        recipeNameInput.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        recipeNameInput.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        nameLimitLabel.topAnchor.constraint(equalTo: recipeNameInput.topAnchor, constant: 5).isActive = true
        nameLimitLabel.trailingAnchor.constraint(equalTo: recipeNameInput.trailingAnchor).isActive = true
        
        descriptionInput.topAnchor.constraint(equalTo: recipeNameInput.bottomAnchor, constant: 20).isActive = true
        descriptionInput.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
        descriptionInput.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        descriptionInput.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        descriptionLimitLabel.topAnchor.constraint(equalTo: descriptionInput.topAnchor, constant: 5).isActive = true
        descriptionLimitLabel.trailingAnchor.constraint(equalTo: descriptionInput.trailingAnchor).isActive = true
        
        categoryLabel.topAnchor.constraint(equalTo: descriptionInput.bottomAnchor, constant: 20).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: recipeNameInput.leadingAnchor).isActive = true
        
        addCategoryButton.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor).isActive = true
        addCategoryButton.trailingAnchor.constraint(equalTo: descriptionInput.trailingAnchor).isActive = true
        addCategoryButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addCategoryButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        categoriesCollectionView.topAnchor.constraint(equalTo: addCategoryButton.bottomAnchor, constant: 20).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: descriptionInput.leadingAnchor).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: descriptionInput.trailingAnchor).isActive = true
        categoriesCollectionView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        ingredientsLabel.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 20).isActive = true
        ingredientsLabel.leadingAnchor.constraint(equalTo: recipeNameInput.leadingAnchor).isActive = true
        
        addIngredientButton.centerYAnchor.constraint(equalTo: ingredientsLabel.centerYAnchor).isActive = true
        addIngredientButton.trailingAnchor.constraint(equalTo: descriptionInput.trailingAnchor).isActive = true
        addIngredientButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addIngredientButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        ingredientView.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 5).isActive = true
        ingredientView.leadingAnchor.constraint(equalTo: recipeNameInput.leadingAnchor).isActive = true
        ingredientView.trailingAnchor.constraint(equalTo: recipeNameInput.trailingAnchor).isActive = true
        
        instructionInput.topAnchor.constraint(equalTo: ingredientView.bottomAnchor, constant: 20).isActive = true
        instructionInput.leadingAnchor.constraint(equalTo: recipeNameInput.leadingAnchor).isActive = true
        instructionInput.trailingAnchor.constraint(equalTo: recipeNameInput.trailingAnchor).isActive = true
        instructionInput.heightAnchor.constraint(equalToConstant: 200).isActive = true
        instructionInput.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -200).isActive = true
    }
    
    @objc private func saveButtonPressed(_ sender: UIButton) {
        let name = recipeNameInput.inputText
        let image = recipe.image
        let description = descriptionInput.inputText
        let categories = categoriesViewModel.selectedCategories
        let ingredients = ingredientView.ingredientViewModel.ingredients
        let instruction = instructionInput.inputText
        let isFavorite = recipe.isFavorite
        let tag = recipe.tag
        let recipe = RecipeModel(name: name, image: image, description: description, instruction: instruction, categories: categories, ingredients: ingredients, isFavorite: isFavorite, tag: tag, coreDataRef: recipe.coreDataRef)
        
        delegate?.saveRecipe(recipe: recipe)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addIngredientButtonPressed(_ sender: UIButton) {
        let coreData = AppDelegate.sharedCoreData
        let viewModel = IngredientViewModel(ingredients: recipe.ingredients, rowHeight: 40, indentifier: "id", headerIdentifier: "headId")
        let vc = AddIngredientViewController(ingredientViewModel: viewModel, coreData: coreData)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func addCategoryButtonPressed(_ sender: UIButton) {
        let coreData = AppDelegate.sharedCoreData
        let vc = AddCategoryViewController(coreData: coreData)
        present(vc, animated: true)
    }
}

extension EditRecipeViewController: HomeCategoriesViewModelDelegate {
    func categorySelected(selected: [String]) {
        
    }
}

extension EditRecipeViewController: AddIngredientViewControllerDelegate {
    func updateIngredient(ingredients: [(IngredientModel, Double)]) {
        recipe.ingredients = ingredients
        ingredientView.ingredientViewModel.ingredients = ingredients
        ingredientView.reloadHeight()
    }
}

extension EditRecipeViewController: InputTextViewDelegate {
    func inputTextChanged(old: String, new: String, tag: Int) {
        if tag == 1 {
            nameLimitLabel.text = "limit: \(new.count)/50"
            if new.count >= 50 {
                nameLimitLabel.textColor = .red
            } else {
                nameLimitLabel.textColor = .black
            }
        } else if tag == 2 {
            descriptionLimitLabel.text = "limit: \(new.count)/250"
            if new.count >= 250 {
                descriptionLimitLabel.textColor = .red
            } else {
                descriptionLimitLabel.textColor = .black
            }
        }
    }
}
