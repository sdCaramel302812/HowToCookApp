//
//  EditRecipeViewController.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/26/23.
//

import UIKit

class EditRecipeViewController: UIViewController {
    private var recipe: RecipeModel
    
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
    
    private let descriptionInput = InputTextView(labelText: "Description")
    
    //private let category
    
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
    
    private let instructionInput = InputTextView(labelText: "Instruction")
    
    
    init(recipe: RecipeModel) {
        self.recipe = recipe
        recipeNameInput.inputText = recipe.name
        descriptionInput.inputText = recipe.description
        instructionInput.inputText = recipe.instruction
        
        let ingredientViewModel = IngredientViewModel(
            ingredients: recipe.ingredients,
            rowHeight: ingredientRowHeight,
            indentifier: ingredientTableCellId,
            headerIdentifier: ingredientTableHeaderId)
        ingredientView = IngredientView(ingredientViewModel: ingredientViewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Save", style: .plain, target: self, action: nil), animated: true)
        
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(recipeNameInput)
        scrollView.addSubview(descriptionInput)
        scrollView.addSubview(ingredientsLabel)
        scrollView.addSubview(ingredientView)
        scrollView.addSubview(instructionInput)
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
        
        descriptionInput.topAnchor.constraint(equalTo: recipeNameInput.bottomAnchor, constant: 20).isActive = true
        descriptionInput.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
        descriptionInput.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        descriptionInput.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        ingredientsLabel.topAnchor.constraint(equalTo: descriptionInput.bottomAnchor, constant: 20).isActive = true
        ingredientsLabel.leadingAnchor.constraint(equalTo: recipeNameInput.leadingAnchor).isActive = true
        
        ingredientView.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 5).isActive = true
        ingredientView.leadingAnchor.constraint(equalTo: recipeNameInput.leadingAnchor).isActive = true
        ingredientView.trailingAnchor.constraint(equalTo: recipeNameInput.trailingAnchor).isActive = true
        
        instructionInput.topAnchor.constraint(equalTo: ingredientView.bottomAnchor, constant: 20).isActive = true
        instructionInput.leadingAnchor.constraint(equalTo: recipeNameInput.leadingAnchor).isActive = true
        instructionInput.trailingAnchor.constraint(equalTo: recipeNameInput.trailingAnchor).isActive = true
        instructionInput.heightAnchor.constraint(equalToConstant: 200).isActive = true
        instructionInput.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -200).isActive = true
    }
}
