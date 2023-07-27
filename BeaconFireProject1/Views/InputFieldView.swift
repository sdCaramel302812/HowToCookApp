//
//  InputFieldView.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/26/23.
//

import UIKit

class InputFieldView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    

    
    var inputText: String {
        get {
            return textField.text ?? ""
        }
        set(newValue) {
            textField.text = newValue
        }
    }
    
    var isSecureText: Bool {
        get {
            textField.isSecureTextEntry
        }
        set(newValue) {
            textField.isSecureTextEntry = newValue
        }
    }
    
    private var portion: Double = 0
    
    init(labelText: String, portion: Double) {
        super.init(frame: .zero)
        label.text = labelText
        self.portion = min(max(portion, 0), 1)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(textField)
        
        label.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: textField.leadingAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: portion).isActive = true
        
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 - portion).isActive = true
    }
}
