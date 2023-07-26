//
//  TagView.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/26/23.
//

import UIKit

class TagView: UIView {
    var isSelectable = true
    var isSelected = false
    
    let height = 30.0
    var width: CGFloat {
        get {
            return CGFloat(text.count) * 10 + 10
        }
    }
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var text: String {
        get {
            button.titleLabel?.text ?? ""
        }
        set(newValue) {
            button.setTitle(newValue, for: .normal)
        }
    }
    
    init() {
        super.init(frame: .zero)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = height / 2
        
        addSubview(button)
        
        //setConstraints()
    }
    
    func setConstraints() {
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
        
        button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
    }
    
    func toggle() {
        guard isSelectable else {
            return
        }
        isSelected = !isSelected
        if isSelected {
            button.backgroundColor = UIColor(white: 210 / 255, alpha: 1)
        } else {
            button.backgroundColor = .clear
        }
    }
    
    func addTarget(_ target: Any?, action: Selector, for event: UIControl.Event) {
        button.addTarget(target, action: action, for: event)
    }
}
