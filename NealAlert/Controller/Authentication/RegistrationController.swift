//
//  RegistrationController.swift
//  NealAlert
//
//  Created by Antoine Perry on 5/31/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    // MARK: - Properties
    
    private let titleLabel = Utilities().attributedText("Neal", "Alert")
        let label = UILabel()
    
    private lazy var emailContainerView: UIView = {
        return Utilities().inputContainerView(with: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
    }()
    
    private lazy var passwordContainerView: UIView = {
        return Utilities().inputContainerView(with: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
    }()
    
    private let emailTextField: UITextField = {
        return Utilities().textField(withPlaceholder: "Email")
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let signUpButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let exitButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.tintColor = .white
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have account?", "Login.")
        button.addTarget(self, action: #selector(showLoginController), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyBoardWhenTappedAround()
    }
    
    // MARK: - Selectors
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                let alert = UIAlertController(title: "Try again?", message: "\(error.localizedDescription)", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default))
                self.present(alert, animated: true)
                
                return
            }
            print("DEBUG: Sucessfully created user and uploaded user data")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func showLoginController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI () {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .black
        configureBackground()
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        view.addSubview(exitButton)
        exitButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingRight: 16)
        
        let AuthStack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, signUpButton])
        AuthStack.axis = .vertical
        AuthStack.spacing = 20
        
        view.addSubview(AuthStack)
        AuthStack.anchor(top: titleLabel.bottomAnchor, left:  view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
        
    }
}
