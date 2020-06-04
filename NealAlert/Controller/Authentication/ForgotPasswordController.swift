//
//  ForgotPasswordController.swift
//  NealAlert
//
//  Created by Antoine Perry on 5/31/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordController: UIViewController {
    // MARK: - Properties
    
    private let titleLabel = Utilities().attributedText("Neal", "Alert")
    
    private lazy var emailContainerView:UIView = {
        return Utilities().inputContainerView(with: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
    }()
    
    private let emailTextField = Utilities().textField(withPlaceholder: "Email")
    
    private let forgotPasswordButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyBoardWhenTappedAround()
    }
    
    // MARK: - Selectors
    
    @objc func handleForgotPassword() {
        guard let email = emailTextField.text else { return }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                let alert = UIAlertController(title: "Try again?", message: "\(error.localizedDescription)", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default))
                self.present(alert, animated: true)
                
                return
            } else {
                let alert = UIAlertController(title: "Thanks!", message: "We just sent you an email with instructions to reset your password", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { alert in
                    self.navigationController?.popViewController(animated: true)
                }))
            }
        }
    }
    
    @objc func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI () {
        view.backgroundColor = .black
        configureBackground()
        
        view.addSubview(titleLabel)
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        view.addSubview(exitButton)
        exitButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, forgotPasswordButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, left:  view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    }
}
