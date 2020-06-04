//
//  ContactsController.swift
//  NealAlert
//
//  Created by Antoine Perry on 5/28/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import UIKit
import CoreData
import Firebase

private var reuseidentifier = "ContactsCell"

class ContactsController: UITableViewController {
    
    // MARK: - Properties
    
    var fetchResultsController: NSFetchedResultsController<Contacts>!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareFetchResultsController()
        configureUI()
        //authenticateUser()
        logout()
    }
    
    // MARK: - Selectors
    
    @objc func addButtonPressed() {
        let controller = AddContactController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
    // MARK: - Helpers
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.presentLoginController()
        } catch {
            print("DEBUG: Error signing out...")
        }
    }
    
    fileprivate func presentLoginController() {
        let controller = LoginController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                self.presentLoginController()
            }
        } else {
            print("DEBUG: User is logged in...")
        }
    }
    
    func configureUI() {
        tableView.backgroundColor = .white
        tableView.register(ContactsCell.self, forCellReuseIdentifier: reuseidentifier)
        configureNavBar()
    }
    
    func configureNavBar() {
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }
}

// MARK: - UITableViewDataSource

extension ContactsController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseidentifier, for: indexPath) as! ContactsCell
        let contact = self.contact(for: indexPath)
        cell.nameLabel.text = contact.contactname
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ContactsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = AddContactController()
        controller.contact = self.contact(for: indexPath)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        deleteContact(at: indexPath)
    }
}

// MARK: - Core Data

extension ContactsController {
    private func prepareFetchResultsController() {
        fetchResultsController = CoreDataManager.shared.fetchedResultsController()
        
        fetchResultsController.delegate = self
        
        do {
            try fetchResultsController.performFetch()
        } catch let error {
            fatalError("Failed to init fetchedResultsController. \(error.localizedDescription)")
        }
    }
}

// MARK: - NSFetchedResultsController Helper

extension ContactsController {
    private var sections: [NSFetchedResultsSectionInfo] {
        return fetchResultsController.sections ?? []
    }
    
    private func contact(for indexPath: IndexPath) -> Contacts {
        return fetchResultsController.object(at: indexPath)
    }
    
    private func deleteContact(at indexPath: IndexPath) {
        CoreDataManager.shared.remove(contact(for: indexPath))
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ContactsController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .move, .update:
        break
        @unknown default:
            fatalError("Unknow type \(type) detected")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        @unknown default:
            fatalError("Unknow type \(type) detected")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
