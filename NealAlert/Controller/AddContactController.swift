//
//  AddContactController.swift
//  NealAlert
//
//  Created by Antoine Perry on 5/29/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import UIKit
import CoreData

class AddContactController: UIViewController {
    
    // MARK: - Properties
    
    var contact: Contacts? {
        didSet {
            guard let contact = contact else { return }
            contactNameTextField.text = contact.contactname
            contactNumberTextField.text = contact.contactnumber
        }
    }
    
    private let contactNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .black
        return label
    }()
    
    private let contactNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Number"
        label.textColor = .black
        return label
    }()
    
    private var contactNameTextField = UITextField().setupContactTF()
    
    private var contactNumberTextField = UITextField().setupContactTF()
    
    private lazy var smsButton: UIButton = {
        let button = UIButton().setupButton("SMS Message")
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton().setupButton("Save Contact")
        button.addTarget(self, action: #selector(saveContact), for: .touchUpInside)
        return button
    }()
    
    private lazy var messageTextField: UITextView = {
       let tf = UITextView()
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = .white
        tf.textColor = .black
        tf.text =  "Your car's service is complete and is ready to be picked up from Neal Tire during business hours."
        tf.bounces = true
        tf.isScrollEnabled = true
        tf.showsVerticalScrollIndicator = true
        tf.isEditable = true
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.5
        return tf
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        populateInformation()
        hideKeyBoardWhenTappedAround()
    }
    
    // MARK: Selectors
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveContact() {
        guard let contactname = contactNameTextField.text, contactNameTextField.hasText else { return }
        guard let contactnumber = contactNumberTextField.text, contactNumberTextField.hasText else { return }
        
        if contact == nil {
            CoreDataManager.shared.addContacts(contactname, contactnumber)
            dismiss(animated: true, completion: nil)
        } else {
            contact?.contactname = contactNameTextField.text
            contact?.contactnumber = contactNumberTextField.text
        }
        guard let contact = contact else { return }
        CoreDataManager.shared.updateContact(contact: contact)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func sendMessage() {
        guard let toNumber = contactNumberTextField.text, contactNumberTextField.hasText else { return }
        guard let body = messageTextField.text, messageTextField.hasText else { return }

        //SendMessageService.shared.sendMessage(toNumber, body, body)
        SendMessageService.shared.sendMessage(toNumber, body)
        
        
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        let contactsStack = UIStackView(arrangedSubviews: [contactNameLabel, contactNameTextField,
                                                           contactNumberLabel, contactNumberTextField])
        contactsStack.axis = .vertical
        contactsStack.alignment = .fill
        contactsStack.distribution = .fillProportionally
        contactsStack.spacing = 10
        
        view.addSubview(contactsStack)
        contactsStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                             paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(smsButton)
        smsButton.anchor(top: contactsStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(messageTextField)
        messageTextField.anchor(top: smsButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
        messageTextField.setDimensions(width: 350, height: 200)
        
        view.addSubview(saveButton)
        saveButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingBottom: 30, paddingRight: 20)
        
    }
    
    func populateInformation() {
        if contact == nil {
            self.navigationItem.title = "Add New Data"
        } else {
            self.navigationItem.title = contact?.contactname
            contactNameTextField.text = contact?.contactname
            contactNumberTextField.text = contact?.contactnumber
            
            saveButton.setTitle("Update Contact", for: .normal)
        }
    }
    
}

