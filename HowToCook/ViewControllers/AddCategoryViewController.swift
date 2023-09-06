//
//  AddCategoryViewController.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/28/23.
//

import UIKit

protocol AddCategoryViewControllerDelegate: AnyObject {
    func saveCategory()
}

class AddCategoryViewController: UIViewController {
    let coreData: CoreDataStack
    weak var delegate: AddCategoryViewControllerDelegate?
    
    private let categoryInput = InputFieldView(labelText: "Category", portion: 0.4)
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .tintColor
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(coreData: CoreDataStack) {
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
        
        view.addSubview(categoryInput)
        view.addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        categoryInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        categoryInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        categoryInput.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        categoryInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addButton.topAnchor.constraint(equalTo: categoryInput.bottomAnchor, constant: 20).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                   .medium()
               ]
            presentationController.selectedDetentIdentifier = .medium
        }
    }
    
    @objc func addButtonPressed(_ sender: UIButton) {
        saveNewCategory()
        delegate?.saveCategory()
        dismiss(animated: true)
    }
    
    func saveNewCategory() {
        let context = coreData.persistentContainer.viewContext
        let category = Categories(context: context)
        category.name = categoryInput.inputText
        coreData.saveContext()
    }
}
