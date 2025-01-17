//
//  MyTripsView.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 17/1/25.
//

import UIKit
import SnapKit

class MyTripsView: UIView {
    
    // MARK: - Subviews
    let addTourButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Tour", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()

    let yearStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let monthStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
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
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
    
    // MARK: - Setup
    private func setupConstraints() {
        addSubviews(addTourButton, yearStackView, monthStackView, weekdayHeader, collectionView, tableView)
        addTourButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(4)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }

        yearStackView.snp.makeConstraints { make in
            make.top.equalTo(addTourButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        monthStackView.snp.makeConstraints { make in
            make.top.equalTo(yearStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        weekdayHeader.snp.makeConstraints { make in
            make.top.equalTo(monthStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(weekdayHeader.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(250)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
