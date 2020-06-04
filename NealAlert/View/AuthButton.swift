//
//  AuthButton.swift
//  NealAlert
//
//  Created by Antoine Perry on 5/31/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import UIKit

class AuthButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.cornerRadius = 5
        backgroundColor = .blue
        setTitleColor(.white, for: .normal)
        setTitle("Log In", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
