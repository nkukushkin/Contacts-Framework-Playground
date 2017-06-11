//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Nikita Kukushkin on 21/05/2017.
//  Copyright © 2017 Nikita Kukushkin. All rights reserved.
//

import Contacts
import ContactsUI

class ContactsViewController: UITableViewController {

    fileprivate var selectedProperties: [CNContactProperty] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    @IBAction private func chooseButtonTapped(_ sender: UIBarButtonItem) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self

        // Show contacts that have at least 1 phone number
        contactPicker.predicateForEnablingContact = NSPredicate(
            format: "\(CNContactPhoneNumbersKey).@count > 0"
        )

        // Show only phone numbers in a contact card
        contactPicker.displayedPropertyKeys = [
            CNContactPhoneNumbersKey
        ]

        // Return phone number property when tapped
        contactPicker.predicateForSelectionOfProperty = NSPredicate(
            format: "key == '\(CNContactPhoneNumbersKey)'"
        )

        present(contactPicker, animated: true)
    }
}

// Implementing delegate methods affects CNContactPickerViewController behaviour!
extension ContactsViewController: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        guard contactProperty.key == CNContactPhoneNumbersKey else { return }

        selectedProperties = [contactProperty]
    }
}

// MARK: - UITableViewDelegate

extension ContactsViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedProperties.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactInfoCell.identifier, for: indexPath) as! ContactInfoCell

        cell.configureWithPhoneNumberProperty(phoneNumberProperty: selectedProperties[indexPath.row])

        return cell
    }
}
