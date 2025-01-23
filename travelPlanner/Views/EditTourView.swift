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
    private let scrollView = UIScrollView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "placeholder_image")
        return imageView
    }()
    
    let startDateField: CustomTextField = {
        let textField = CustomTextField()
        textField.setPlaceholder("Date", color: .white)
        return textField
    }()
    
    let endDateField: CustomTextField = {
        let textField = CustomTextField()
        textField.setPlaceholder("Date", color: .white)
        return textField
    }()
    
    let tourNameField: CustomTextField = {
        let textField = CustomTextField()
        textField.setPlaceholder("What's the tour about", color: .white)
        return textField
    }()
    
    let locationField: CustomTextField = {
        let textField = CustomTextField()
        textField.setPlaceholder("Location", color: .white)
        return textField
    }()
    
    let remarksField: CustomTextView = {
        let textView = CustomTextView()
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
        backgroundColor = UIColor(hex: "#362E83")
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Constraints
    private func setupConstraints() {
        addSubview(scrollView)
        scrollView.addSubviews(imageView, startDateField, endDateField, tourNameField, locationField, remarksField, saveButton, deleteButton)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
        
        startDateField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        endDateField.snp.makeConstraints { make in
            make.top.equalTo(startDateField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        tourNameField.snp.makeConstraints { make in
            make.top.equalTo(endDateField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        locationField.snp.makeConstraints { make in
            make.top.equalTo(tourNameField.snp.bottom).offset(16)
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
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom).offset(-16)
        }
    }
    
    func configure(with tour: Tour) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        imageView.image = UIImage(named: "placeholder_image")
        startDateField.text = formatter.string(from: tour.startDate)
        endDateField.text = formatter.string(from: tour.endDate)
        tourNameField.text = tour.name
        locationField.text = tour.location
        remarksField.text = tour.details
    }
    
    func setUpdateButtonTarget(_ target: Any?, action: Selector) {
        saveButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setDeleteButtonTarget(_ target: Any?, action: Selector) {
        deleteButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
