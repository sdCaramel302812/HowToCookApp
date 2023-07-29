//
//  ViewController.swift
//  BeaconFireProject1
//
//  Created by Li-Yen Yen on 7/26/23.
//

import UIKit

class LoginViewController: UIViewController {
    let loginViewModel: LoginViewModel
    
    private let titleLabel1: UILabel = {
        let label = UILabel()
        label.text = "How To Cook"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel2: UILabel = {
        let label = UILabel()
        label.text = "Programmer's guide"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameInput = InputFieldView(labelText: "Username: ", portion: 0.4)
    
    private let passwordInput: InputFieldView = {
        let view = InputFieldView(labelText: "Password: ", portion: 0.4)
        view.isSecureText = true
        return view
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .tintColor
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let recipeSourceLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipe Source:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recipeSourceLink: UIButton = {
        let button = UIButton()
        button.setTitleColor(.tintColor, for: .normal)
        button.setTitle("https://github.com/Anduin2017/HowToCook/tree/master", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
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
        view.backgroundColor = .white
        
        view.addSubview(usernameInput)
        view.addSubview(passwordInput)
        view.addSubview(loginButton)
        view.addSubview(titleLabel1)
        view.addSubview(titleLabel2)
        view.addSubview(recipeSourceLink)
        view.addSubview(recipeSourceLabel)
        
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        
        recipeSourceLink.addTarget(self, action: #selector(linkPressed), for: .touchUpInside)
        
        if loginViewModel.isLoggedIn {
            pushHomeViewController()
        }
    }

    override func viewDidLayoutSubviews() {
        usernameInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameInput.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        usernameInput.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6).isActive = true
        usernameInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordInput.topAnchor.constraint(equalTo: usernameInput.bottomAnchor).isActive = true
        passwordInput.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6).isActive = true
        passwordInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordInput.bottomAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6).isActive = true
        
        titleLabel2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel2.bottomAnchor.constraint(equalTo: usernameInput.topAnchor, constant: -50).isActive = true
        
        titleLabel1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel1.bottomAnchor.constraint(equalTo: titleLabel2.topAnchor, constant: -10).isActive = true
        
        recipeSourceLink.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recipeSourceLink.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        recipeSourceLink.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        
        recipeSourceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recipeSourceLabel.bottomAnchor.constraint(equalTo: recipeSourceLink.topAnchor, constant: -5).isActive = true
    }
    
    @objc func loginButtonPressed(_ sender: UIButton) {
        loginViewModel.saveLoggedInStatus(loggedIn: true)
        loginViewModel.saveUsername(user: usernameInput.inputText)
        pushHomeViewController()
    }
    
    @objc func linkPressed(_ sender: UIButton) {
        if let url = URL(string: sender.titleLabel?.text ?? "") {
            UIApplication.shared.open(url)
        }
    }
    
    private func pushHomeViewController() {
        let vc = UITabBarController()
        vc.view.backgroundColor = .white
        vc.navigationItem.hidesBackButton = true
        
        let homeVC = HomeViewController()
        homeVC.username = loginViewModel.username
        let settingVC = SettingViewController(loginViewModel: loginViewModel)
        
        homeVC.tabBarItem = UITabBarItem(title: "home", image: UIImage(systemName: "house"), tag: 0)
        settingVC.tabBarItem = UITabBarItem(title: "setting", image: UIImage(systemName: "gear.circle"), tag: 1)
        
        vc.viewControllers = [homeVC, settingVC]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

