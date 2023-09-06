//
//  InputTextView.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/27/23.
//

import UIKit

protocol InputTextViewDelegate: AnyObject {
    func inputTextChanged(old: String, new: String, tag: Int)
}

class InputTextView: UIView {
    weak var delegate: InputTextViewDelegate?
    var inputLimit: Int?
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        //textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    private var oldText = ""

    
    var inputText: String {
        get {
            return textView.text ?? ""
        }
        set(newValue) {
            textView.text = newValue
        }
    }
    
    init(labelText: String) {
        super.init(frame: .zero)
        label.text = labelText
        oldText = labelText
        textView.delegate = self
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(textView)
        
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        textView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

extension InputTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let inputLimit {
            if inputLimit < textView.text.count && oldText != textView.text {
                textView.text = oldText
                return
            }
        }
        delegate?.inputTextChanged(old: oldText, new: textView.text, tag: tag)
        oldText = textView.text
    }
}
