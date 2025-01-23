//
//  AddTourView.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 17/1/25.
//

import UIKit
import SnapKit

class AddTourView: UIView {

    // MARK: - Subviews
    private let scrollView = UIScrollView()
    
    private let weekdayHeader: UIStackView = {
        let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        for weekday in weekdays {
            let label = UILabel()
            label.text = weekday
            label.textAlignment = .center
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            stackView.addArrangedSubview(label)
        }
        return stackView
    }()
    
    let calendarView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(hex: "#FC6736")
        collectionView.layer.cornerRadius = 8
        return collectionView
    }()
    
    let startDateField: CustomTextField = {
        let textField = CustomTextField()
        textField.setPlaceholder("Start Date", color: .white)
        return textField
    }()
    
    let endDateField: CustomTextField = {
        let textField = CustomTextField()
        textField.setPlaceholder("End Date", color: .white)
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
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(hex: "#FC6736")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#362E83")
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        addSubview(scrollView)
        scrollView.addSubviews(weekdayHeader, calendarView, startDateField, endDateField, tourNameField, locationField, remarksField, saveButton)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        weekdayHeader.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(16)
            make.height.equalTo(20) // Fixed height for weekday labels
        }

        calendarView.snp.makeConstraints { make in
            make.top.equalTo(weekdayHeader.snp.bottom).offset(8)
            make.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(16)
            make.height.equalTo(250) // Calendar height
        }

        startDateField.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
        endDateField.snp.makeConstraints { make in
            make.top.equalTo(startDateField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(16)
            make.height.equalTo(40)
        }

        tourNameField.snp.makeConstraints { make in
            make.top.equalTo(endDateField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(16)
            make.height.equalTo(40)
        }

        locationField.snp.makeConstraints { make in
            make.top.equalTo(tourNameField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(16)
            make.height.equalTo(40)
        }

        remarksField.snp.makeConstraints { make in
            make.top.equalTo(locationField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(16)
            make.height.equalTo(100)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(remarksField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(16)
            make.height.equalTo(50)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom).offset(-16)
        }
    }
}
