//
//  ContactInfoCell.swift
//  ContactsExample
//
//  Created by Nikita Kukushkin on 21/05/2017.
//  Copyright © 2017 Nikita Kukushkin. All rights reserved.
//

import UIKit
import Contacts

class ContactInfoCell: UITableViewCell {

    static let identifier = "ContactInfoCell"

    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var phoneNumberLabel: UILabel!
    @IBOutlet fileprivate weak var photoImageView: UIImageView!
}

// MARK: ContactInfoCell + CNContactProperty

extension ContactInfoCell {

    func configureWithPhoneNumberProperty(phoneNumberProperty: CNContactProperty) {
        guard let phoneNumber = phoneNumberProperty.value as? CNPhoneNumber else {
            fatalError("Invalid property!")
        }
        let contact = phoneNumberProperty.contact

        phoneNumberLabel.text = phoneNumber.stringValue
        updateNameLabel(with: contact)
        updatePhotoImageView(with: contact)
    }

    private func updatePhotoImageView(with contact: CNContact) {
        if let image = contact.imageData.map(UIImage.init(data:)) {
            photoImageView.image = image
            photoImageView.isHidden = false
        } else {
            photoImageView.isHidden = true
        }
    }

    private func updateNameLabel(with contact: CNContact) {

        func formatterPersonName(for contact: CNContact) -> String? {
            var personNameComponents = PersonNameComponents()
            personNameComponents.namePrefix = contact.namePrefix
            personNameComponents.givenName = contact.givenName
            personNameComponents.middleName = contact.middleName
            personNameComponents.familyName = contact.familyName
            personNameComponents.nameSuffix = contact.nameSuffix

            let personName = PersonNameComponentsFormatter()
                .string(from: personNameComponents)

            return personName.isEmpty ? nil : personName
        }

        if let personName = formatterPersonName(for: contact) {
            nameLabel.text = personName
        } else {
            nameLabel.text = contact.organizationName
        }
    }


}
