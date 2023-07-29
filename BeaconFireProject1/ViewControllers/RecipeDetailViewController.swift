//
//  RecipeDetailViewController.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/26/23.
//

import UIKit

protocol RecipeDetailViewControllerDelegate: AnyObject {
    func saveRecipe(recipe: RecipeModel, tag: Int)
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
    
    private let categoryStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalCentering
        view.sizeToFit()
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var categorySubviews: [UIView] = []
    
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
    
    private let servingPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private var ingredientView: IngredientView
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
        let ingredientViewModel = IngredientViewModel(
            ingredients: recipe.ingredients,
            rowHeight: ingredientRowHeight,
            indentifier: ingredientTableCellId,
            headerIdentifier: ingredientTableHeaderId)
        ingredientView = IngredientView(ingredientViewModel: ingredientViewModel)
        self.tag = tag
        
        super.init(nibName: nil, bundle: nil)
        setView(recipe: recipe)
        setFavorite(isFavorite: recipe.isFavorite)
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
        scrollView.addSubview(categoryStackView)
        scrollView.addSubview(descriptionTextView)
        scrollView.addSubview(ingredientsLabel)
        scrollView.addSubview(servingPicker)
        scrollView.addSubview(ingredientView)
        scrollView.addSubview(instructionLabel)
        scrollView.addSubview(instructionTextView)
        
        servingPicker.delegate = self
        servingPicker.dataSource = self
        
        addCategoriesView(categories: recipe.categories)
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        //scrollView.contentSize = view.frame.size
        
        let width = view.frame.width
        recipeImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        recipeImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let imageSize = recipeImageView.image?.size
        if let imageSize {
            let heightRatio = imageSize.height / (imageSize.width == 0 ? 1 : imageSize.width)
            recipeImageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: heightRatio).isActive = true
        } else {
            recipeImageView.heightAnchor.constraint(equalToConstant: width * 0.6).isActive = true
        }
        
        recipeNameLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        recipeNameLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 15).isActive = true
        
        favoriteButton.centerYAnchor.constraint(equalTo: recipeNameLabel.centerYAnchor).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        categoryStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        categoryStackView.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: 20).isActive = true
        
        descriptionTextView.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: 20).isActive = true
        descriptionTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        descriptionTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
        
        //descriptionTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        ingredientsLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20).isActive = true
        ingredientsLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor).isActive = true
        
        servingPicker.centerYAnchor.constraint(equalTo: ingredientsLabel.centerYAnchor).isActive = true
        servingPicker.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor).isActive = true
        servingPicker.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        ingredientView.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 5).isActive = true
        ingredientView.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor).isActive = true
        ingredientView.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor).isActive = true
        
        instructionLabel.topAnchor.constraint(equalTo: ingredientView.bottomAnchor, constant: 20).isActive = true
        instructionLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor).isActive = true
        
        instructionTextView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20).isActive = true
        instructionTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        instructionTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
        instructionTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        
        //instructionTextView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        //ingredientsLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    @objc func editButtonPressed(_ sender: UIButton) {
        let vc = EditRecipeViewController(recipe: recipe, title: "Edit Recipe")
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func favoriteButtonPressed(_ sender: UIButton) {
        setFavorite(isFavorite: !recipe.isFavorite)
        
        delegate?.saveRecipe(recipe: recipe, tag: tag)
    }
    
    private func setFavorite(isFavorite: Bool) {
        recipe.isFavorite = isFavorite
        if recipe.isFavorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    private func setView(recipe: RecipeModel) {
        recipeImageView.image = recipe.image
        recipeNameLabel.text = recipe.name
        descriptionTextView.text = recipe.description
        instructionTextView.text = recipe.instruction
    }
    
    private func addCategoriesView(categories: [String]) {
        for subview in categorySubviews {
            categoryStackView.removeArrangedSubview(subview)
        }
        NSLayoutConstraint.deactivate(categorySubviews.flatMap { $0.constraints })
        for subview in categorySubviews {
            subview.removeFromSuperview()
        }
        categorySubviews.removeAll()
        for category in categories {
            let tagView = TagView()
            tagView.isSelectable = false
            tagView.text = category
            tagView.setConstraints()
            categorySubviews.append(tagView)
            categoryStackView.addArrangedSubview(tagView)
        }
    }
}

extension RecipeDetailViewController: EditRecipeViewControllerDelegate {
    func saveRecipe(recipe: RecipeModel) {
        self.recipe = recipe
        setView(recipe: recipe)
        ingredientView.ingredientViewModel.ingredients = recipe.ingredients
        ingredientView.reloadHeight()
        addCategoriesView(categories: recipe.categories)
        delegate?.saveRecipe(recipe: recipe, tag: recipe.tag)
    }
}

extension RecipeDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ingredientView.serving = row + 1
        ingredientView.reloadHeight()
    }
}

extension RecipeDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        String(row + 1)
    }
}
