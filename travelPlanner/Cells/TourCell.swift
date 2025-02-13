//
//  TourCell.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 16/1/25.
//

import UIKit
import SnapKit

class TourCell: UICollectionViewCell {
    static let identifier = "tour_cell"
    
    private let tourImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(hex: "#362E83")
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#362E83")
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(hex: "#362E83")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        setupCellAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellAppearance() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }
    
    private func setupSubviews() {
        contentView.addSubview(tourImageView)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel, locationLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        tourImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(96)
        }
        
        guard let stackView = contentView.subviews.last as? UIStackView else { return }
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(tourImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with tour: Tour) {
        titleLabel.text = tour.name

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"

        let startDate: String
        let endDate: String

        if !tour.startDate.timeIntervalSince1970.isNaN {
            startDate = formatter.string(from: tour.startDate)
        } else {
            startDate = "Unknown Start Date"
        }

        if !tour.endDate.timeIntervalSince1970.isNaN {
            endDate = formatter.string(from: tour.endDate)
        } else {
            endDate = "Unknown End Date"
        }

        dateLabel.text = "\(startDate) - \(endDate)"
        locationLabel.text = tour.location

        tourImageView.image = UIImage(named: "placeholder_image")
    }
}
