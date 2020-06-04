//
//  ContactsCell.swift
//  NealAlert
//
//  Created by Antoine Perry on 5/29/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import UIKit

class ContactsCell: UITableViewCell {
    
    // MARK: - Properties
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        addSubview(nameLabel)
        nameLabel.centerY(inview: self)
        nameLabel.anchor(left: leftAnchor, paddingLeft: 20)
    }
}
