//
//  HomeViewController.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/26/23.
//

import UIKit

class HomeViewController: UIViewController {
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome "
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
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
    
    private let addRecipeButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(hierarchicalColor: .white)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor(red: 10 / 255, green: 95 / 255, blue: 255 / 255, alpha: 0.7)
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        categoriesViewModel = HomeCategoriesViewModel(identifier: categoriesCellIdentifier)
        categoriesCollectionView.delegate = categoriesViewModel
        categoriesCollectionView.dataSource = categoriesViewModel
        categoriesCollectionView.register(HomeCategoriesCell.self, forCellWithReuseIdentifier: categoriesCellIdentifier)
        
        view.addSubview(welcomeLabel)
        view.addSubview(categoriesCollectionView)
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
        
        addRecipeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40).isActive = true
        addRecipeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        addRecipeButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addRecipeButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc private func addButtonPressed(_ sender: UIButton) {
        let mockRecipe = RecipeModel(
            name: "Kung Pao Chicken",
            image: UIImage(named: "KungPaoChicken"),
            description: "Simple sharing of old-school Sichuan cuisine",
            instruction: """
            1. Debone the pistol leg with scissors, beat the chicken noodles with the back of a knife, cut into strips and cut into 1.5cm square cubes; soak in clean water for 10 minutes, remove and dry for later use (if it is chicken breast, you can directly cut into cubes and the subsequent actions)
            
            2. Put 5g of green onion and ginger slices in a bowl, pour 50g of boiling water for later use; cut the white of scallion into 1.5cm round pieces for later use; put the peanuts in a microwave oven for 5 minutes and dry them for later use
            
            3. Add 2g of salt, 5g of dark soy sauce, 15g of cooking wine, and 15g of starch to the diced chicken, stir well until slightly dry; slowly add some onion and ginger water, stir until the diced chicken sticks to your hands; seal it with plastic wrap, and marinate in the refrigerator for 1 hour
            
            4. Cut the dried chili into sections; start the pot, heat up on high heat and turn to low heat; put in the dried chili and dry it until it becomes slightly mushy, then pick it up for later use; dry the Chinese prickly ash until it smells fragrant, then pick it up for later use
            
            5. Turn to high heat, pour in 20g of vegetable oil, 70% heat (the bamboo chopsticks will bubble), add the diced chicken, fry until the top starts to turn white, turn it over with a spatula, fry for 30 seconds, and stir fry evenly
            
            6. Add diced green onion and stir-fry, add the remaining 100g of green onion and ginger water, add a little water (must be hot water); cover the pot, turn to medium-low heat and simmer for 2 minutes;
            
            7. Turn to high heat, add cooked peanuts, dried chili and Chinese prickly ash; add 2g chicken stock, 5g balsamic vinegar, 2g sugar, stir fry evenly;
            
            8. Add 10g of starch and 50g of water to make water starch, add it to the pot, stir fry evenly, and collect the juice to the desired concentration
            
            9. Turn off the heat, pour in 10g of sesame oil, and serve
            """,
            categories: ["non-vegetarian", "lunch"],
            ingredients: [
                (ingredient: IngredientModel(name: "chicken breasts", unit: "g"), qty: 10.0)
            ])
        
        let vc = RecipeDetailViewController(recipe: mockRecipe)
        navigationController?.pushViewController(vc, animated: true)
    }
}
