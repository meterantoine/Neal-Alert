//
//  LoginController.swift
//  NealAlert
//
//  Created by Antoine Perry on 5/31/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
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
    
    private let LoginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = Utilities().attributedButton("Forgot Password?", "Get help here.")
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Don't have an account?", "Sign up.")
        button.addTarget(self, action: #selector(handleShowRegistrationController), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyBoardWhenTappedAround()
        
    }
    
    // MARK: - Selectors
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: There was an error \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true)
        }
        
    }
    
    @objc func handleForgotPassword() {
        let controller = ForgotPasswordController()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func handleShowRegistrationController() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
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
        
        let AuthStack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, LoginButton, forgotPasswordButton])
        AuthStack.axis = .vertical
        AuthStack.spacing = 20
        
        view.addSubview(AuthStack)
        AuthStack.anchor(top: titleLabel.bottomAnchor, left:  view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
        
    }
}
