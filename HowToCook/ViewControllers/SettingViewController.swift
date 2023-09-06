//
//  SettingViewController.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/26/23.
//

import UIKit

class SettingViewController: UIViewController {
    let loginViewModel: LoginViewModel
    private let defaults = UserDefaults.standard
    private let isMetric = "isMetric"
    
    private let settingLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let toggleLabel: UILabel = {
        let label = UILabel()
        label.text = "Measurement: imperial"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logoutLabel: UILabel = {
        let label = UILabel()
        label.text = "Log out"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let toggleButton: UISwitch = {
        let button = UISwitch()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("LOGOUT", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(settingLabel)
        view.addSubview(toggleLabel)
        view.addSubview(logoutLabel)
        view.addSubview(toggleButton)
        view.addSubview(logoutButton)
        
        toggleButton.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        
        if defaults.bool(forKey: isMetric) {
            toggleButton.isOn = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        settingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        settingLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        toggleLabel.topAnchor.constraint(equalTo: settingLabel.bottomAnchor, constant: 20).isActive = true
        toggleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        logoutLabel.topAnchor.constraint(equalTo: toggleLabel.bottomAnchor, constant: 20).isActive = true
        logoutLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        toggleButton.centerYAnchor.constraint(equalTo: toggleLabel.centerYAnchor).isActive = true
        toggleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        logoutButton.centerYAnchor.constraint(equalTo: logoutLabel.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc private func toggleChanged(_ sender: UISwitch) {
        if sender.isOn {
            toggleLabel.text = "Measurement: metric"
            defaults.set(true, forKey: isMetric)
        } else {
            toggleLabel.text = "Measurement: imperial"
            defaults.set(false, forKey: isMetric)
        }
    }
    
    @objc private func logoutButtonPressed(_ sender: UIButton) {
        loginViewModel.saveLoggedInStatus(loggedIn: false)
        navigationController?.popViewController(animated: true)
    }
}
