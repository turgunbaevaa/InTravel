//
//  EditTourView.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 22/1/25.
//

import UIKit
import SnapKit

class EditTourView: UIView {

    //MARK: Subviews
    let dateField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Date"
        textField.borderStyle = .roundedRect
        return textField
    }()

    let nameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "What's the tour about"
        textField.borderStyle = .roundedRect
        return textField
    }()

    let locationField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Location"
        textField.borderStyle = .roundedRect
        return textField
    }()

    let remarksField: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()

    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Update", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete tour", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemBackground
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: 
    private func setupConstraints() {
        addSubviews(dateField, nameField, locationField, remarksField, saveButton, deleteButton)

        dateField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        nameField.snp.makeConstraints { make in
            make.top.equalTo(dateField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        locationField.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        remarksField.snp.makeConstraints { make in
            make.top.equalTo(locationField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(remarksField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }

        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }

    // Configure method to populate fields with tour data
    func configure(with tour: Tour) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d - MMM d" // Customize date format
        dateField.text = formatter.string(from: tour.startDate) + " - " + formatter.string(from: tour.endDate)
        nameField.text = tour.name
        locationField.text = tour.location
        remarksField.text = tour.details
    }
}
