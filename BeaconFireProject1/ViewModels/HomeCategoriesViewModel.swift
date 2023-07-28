//
//  HomeCategoriesViewModel.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/26/23.
//

import Foundation
import UIKit

protocol HomeCategoriesViewModelDelegate: AnyObject {
    func categorySelected(selected: [String])
}

class HomeCategoriesViewModel: NSObject {
    weak var delegate: HomeCategoriesViewModelDelegate?
    
    var isEditable = true
    private var coreData: CoreDataStack?
    var categories: [String] = []
    private var isSelected: [String: Bool] = [:]
    
    var selectedCategories: [String] {
        get {
            var result: [String] = []
            for (key, value) in isSelected {
                if value {
                    result.append(key)
                }
            }
            return result
        }
    }
    
    let reuseIdentifier: String
    
    init(coreData: CoreDataStack, identifier: String) {
        self.coreData = coreData
        reuseIdentifier = identifier
        
        for category in categories {
            isSelected[category] = false
        }
        super.init()
        loadCoreData()
    }
    
    init(categories: [String], identifier: String) {
        self.categories = categories
        reuseIdentifier = identifier
        
        for category in categories {
            isSelected[category] = false
        }
    }
    
    func loadCoreData() {
        let categoryRequest = Categories.fetchRequest()
        let category = coreData?.fetch(categoryRequest)
        guard let category else {
            coreData?.initCoreData()
            return
        }
        self.categories = categoriesToString(categories: category)
    }
    
    private func categoriesToString(categories: [Categories]) -> [String] {
        categories.map { $0.name ?? "" }
    }
    
    func categorySelected(_ sender: TagView) {
        sender.toggle()
        isSelected[categories[sender.tag]] = sender.isSelected
        delegate?.categorySelected(selected: selectedCategories)
    }
}

extension HomeCategoriesViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = categories[indexPath.row].count * 10 + 10
        return CGSize(width: width, height: 30)
    }
}

extension HomeCategoriesViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HomeCategoriesCell else {
            let newCell = HomeCategoriesCell()
            newCell.tagView.isSelectable = isEditable
            newCell.tagView.text = categories[indexPath.row]
            newCell.tagView.setConstraints()
            newCell.tagView.tag = indexPath.row
            newCell.tagView.addTarget(action: categorySelected, for: .touchUpOutside)
            return newCell
        }
        cell.tagView.isSelectable = isEditable
        cell.tagView.text = categories[indexPath.row]
        cell.tagView.setConstraints()
        cell.tagView.tag = indexPath.row
        cell.tagView.addTarget(action: categorySelected, for: .touchUpInside)
        return cell
    }
}
