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
    
    private var heightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override var tag: Int {
        get {
            return button.tag
        }
        set(newValue) {
            button.tag = newValue
        }
    }
    
    var text: String {
        get {
            button.titleLabel?.text ?? ""
        }
        set(newValue) {
            button.setTitle(newValue, for: .normal)
        }
    }
    
    var buttonPressHandler: ((_ tagView: TagView) -> ())?
    
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
        if let widthConstraint {
            removeConstraint(widthConstraint)
        }
        if let heightConstraint {
            removeConstraint(heightConstraint)
        }
        
        widthConstraint = widthAnchor.constraint(equalToConstant: width)
        widthConstraint!.isActive = true
        heightConstraint = heightAnchor.constraint(equalToConstant: height)
        heightConstraint!.isActive = true
        
        button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
    }
    
    func setWidth(width: Double) {
        if let widthConstraint {
            removeConstraint(widthConstraint)
        }
        widthConstraint = widthAnchor.constraint(equalToConstant: width)
        widthConstraint!.isActive = true
    }
    
    func toggle() {
        guard isSelectable else {
            return
        }
        isSelected = !isSelected
        if isSelected {
            button.backgroundColor = UIColor(red: 10 / 255, green: 95 / 255, blue: 255 / 255, alpha: 0.7)
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .clear
            button.setTitleColor(.darkGray, for: .normal)
        }
    }
    
    func addTarget(action: @escaping (_ tagView: TagView) -> (), for event: UIControl.Event) {
        // propagate touch event to tagview
        buttonPressHandler = action
        button.addTarget(self, action: #selector(buttonPressed), for: event)
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        buttonPressHandler?(self)
    }
}
