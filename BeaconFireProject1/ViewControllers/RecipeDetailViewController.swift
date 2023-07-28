//
//  RecipeDetailViewController.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/26/23.
//

import UIKit

protocol RecipeDetailViewControllerDelegate: AnyObject {
    func updateRecipe(recipe: RecipeModel, tag: Int)
}

class RecipeDetailViewController: UIViewController {
    private var recipe: RecipeModel
    private let tag: Int
    weak var delegate: RecipeDetailViewControllerDelegate?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 25)
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
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.textAlignment = .center
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipe Ingredients"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ingredientView: IngredientView
    private let ingredientRowHeight = 30.0
    private let ingredientTableCellId = "ingredientTableCell"
    private let ingredientTableHeaderId = "ingredientTableHeader"
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Instruction"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let instructionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    init(recipe: RecipeModel, tag: Int) {
        self.recipe = recipe
        recipeImageView.image = recipe.image
        recipeNameLabel.text = recipe.name
        descriptionTextView.text = recipe.description
        instructionTextView.text = recipe.instruction
        
        let ingredientViewModel = IngredientViewModel(
            ingredients: recipe.ingredients,
            rowHeight: ingredientRowHeight,
            indentifier: ingredientTableCellId,
            headerIdentifier: ingredientTableHeaderId)
        ingredientView = IngredientView(ingredientViewModel: ingredientViewModel)
        
        self.tag = tag
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonPressed)), animated: true)
        scrollView.contentInsetAdjustmentBehavior = .never
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(recipeImageView)
        scrollView.addSubview(recipeNameLabel)
        scrollView.addSubview(favoriteButton)
        scrollView.addSubview(descriptionTextView)
        scrollView.addSubview(ingredientsLabel)
        scrollView.addSubview(ingredientView)
        scrollView.addSubview(instructionLabel)
        scrollView.addSubview(instructionTextView)
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.contentSize = view.frame.size
        
        let width = view.frame.width
        recipeImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        recipeImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let imageSize = recipeImageView.image?.size
        if let imageSize {
            let heightRatio = imageSize.height / (imageSize.width == 0 ? 1 : imageSize.width)
            recipeImageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, constant: heightRatio).isActive = true
        } else {
            recipeImageView.heightAnchor.constraint(equalToConstant: width * 0.6).isActive = true
        }
        
        recipeNameLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        recipeNameLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 15).isActive = true
        
        favoriteButton.centerYAnchor.constraint(equalTo: recipeNameLabel.centerYAnchor).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        descriptionTextView.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: 20).isActive = true
        descriptionTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        descriptionTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
        
        ingredientsLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20).isActive = true
        ingredientsLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor).isActive = true
        
        ingredientView.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 5).isActive = true
        ingredientView.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor).isActive = true
        ingredientView.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor).isActive = true
        
        instructionLabel.topAnchor.constraint(equalTo: ingredientView.bottomAnchor, constant: 20).isActive = true
        instructionLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor).isActive = true
        
        instructionTextView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20).isActive = true
        instructionTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        instructionTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
        instructionTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc func editButtonPressed(_ sender: UIButton) {
        let vc = EditRecipeViewController(recipe: recipe, title: "Edit Recipe")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func favoriteButtonPressed(_ sender: UIButton) {
        recipe.isFavorite = !recipe.isFavorite
        
        if recipe.isFavorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        delegate?.updateRecipe(recipe: recipe, tag: tag)
    }
}
