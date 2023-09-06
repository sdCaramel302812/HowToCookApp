//
//  AddIngredientViewController.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/28/23.
//

import UIKit

protocol AddIngredientViewControllerDelegate: AnyObject {
    func updateIngredient(ingredients: [(IngredientModel, Double)])
}

class AddIngredientViewController: UIViewController {
    weak var delegate: AddIngredientViewControllerDelegate?
    let coreData: CoreDataStack
    
    private var addedIngredients: [String: (unit: String, qty: Double)] = [:]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Ingredient"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextInput = InputFieldView(labelText: "name", portion: 0.4)
    
    private let qtyTextInput = InputFieldView(labelText: "quantity", portion: 0.4)
    
    private let unitTextInput = InputFieldView(labelText: "unit", portion: 0.4)
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .tintColor
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var ingredientView: IngredientView!
    private var ingredientViewModel: IngredientViewModel
    
    private let identifier = "ingredientCell"
    private let headerIdentifier = "ingredientHeaderCell"
    
    init(ingredientViewModel: IngredientViewModel, coreData: CoreDataStack) {
        self.ingredientViewModel = ingredientViewModel
        self.coreData = coreData
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        ingredientView = IngredientView(ingredientViewModel: ingredientViewModel)
        ingredientView.isSwipeable = true
        
        view.addSubview(titleLabel)
        view.addSubview(nameTextInput)
        view.addSubview(qtyTextInput)
        view.addSubview(unitTextInput)
        view.addSubview(addButton)
        view.addSubview(ingredientView)
        
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        nameTextInput.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        nameTextInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextInput.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        nameTextInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        qtyTextInput.topAnchor.constraint(equalTo: nameTextInput.bottomAnchor).isActive = true
        qtyTextInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        qtyTextInput.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        qtyTextInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        unitTextInput.topAnchor.constraint(equalTo: qtyTextInput.bottomAnchor).isActive = true
        unitTextInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        unitTextInput.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        unitTextInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addButton.topAnchor.constraint(equalTo: unitTextInput.bottomAnchor, constant: 10).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        ingredientView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20).isActive = true
        //ingredientView.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        ingredientView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ingredientView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    @objc private func addButtonPressed(_ sender: UIButton) {
        let name = nameTextInput.inputText
        let unit = unitTextInput.inputText
        let qty = Double(qtyTextInput.inputText) ?? 0
        ingredientView.addIngredient(ingredient: (IngredientModel(name: name, unit: unit), qty: qty))
        
        if let (_, prevQty) = addedIngredients[name] {
            addedIngredients[name] = (unit, qty + prevQty)
        } else {
            addedIngredients[name] = (unit, qty)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveNewIngredients()
        delegate?.updateIngredient(ingredients: ingredientViewModel.ingredients)
    }
    
    func saveNewIngredients() {
        let context = coreData.persistentContainer.viewContext
        let ingredientRequest = Ingredients.fetchRequest()
        let ingredientRefs = coreData.fetch(ingredientRequest)
        for (name, (unit, _)) in addedIngredients {
            if let ingredientRefs {
                if ingredientRefs.contains(where: { $0.name == name }) {
                    continue
                }
            }
            let ingredient = Ingredients(context: context)
            ingredient.name = name
            ingredient.unit = unit
        }
        coreData.saveContext()
    }
}
