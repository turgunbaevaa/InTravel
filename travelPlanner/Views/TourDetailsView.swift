//
//  TourDetailsView.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 22/1/25.
//

import UIKit
import SnapKit

class TourDetailsView: UIView {

    // MARK: - Subviews
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "placeholder_image")  
        return imageView
    }()

    private let datesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()

    private let remarksLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.orange
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
        addSubviews(imageView, datesLabel, locationLabel, remarksLabel, editButton)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }

        datesLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(datesLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        remarksLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        editButton.snp.makeConstraints { make in
            make.top.equalTo(remarksLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }

    // MARK: - Public Methods
    func configure(with tour: Tour) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        let dateRange = "\(formatter.string(from: tour.startDate)) - \(formatter.string(from: tour.endDate))"
        datesLabel.text = dateRange
        locationLabel.text = "📍 \(tour.location)"
        remarksLabel.text = tour.details
        imageView.image = UIImage(named: "placeholder_image")
    }

    func setEditButtonTarget(_ target: Any?, action: Selector) {
        editButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
