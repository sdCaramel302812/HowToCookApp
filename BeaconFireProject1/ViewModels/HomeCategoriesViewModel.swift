//
//  HomeCategoriesViewModel.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/26/23.
//

import Foundation
import UIKit

class HomeCategoriesViewModel: NSObject {
    let categories = [
        "seafood",
        "special",
        "lunch",
        "vegetarian",
        "breakfast"
    ]
    
    let reuseIdentifier: String
    
    init(identifier: String) {
        reuseIdentifier = identifier
    }
}

extension HomeCategoriesViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
            return HomeCategoriesCell()
        }
        cell.tagView.isSelectable = true
        cell.tagView.text = categories[indexPath.row]
        cell.tagView.setConstraints()
        return cell
    }
    
    
}
