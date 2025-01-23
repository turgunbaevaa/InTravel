//
//  DestinationsCollectionViewCell.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 14/1/25.
//

import UIKit
import SnapKit

class DestinationCell: UICollectionViewCell {
    
    static let reuseId = "destination_cell"
    
    let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "city"))
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let nameLabel = TravelPlannerSubTitleLabel(fontSize: 12, weight: .semibold)
    let priceLabel = TravelPlannerSubTitleLabel(fontSize: 10, weight: .semibold)
    let descriptionLabel = TravelPlannerSubTitleLabel(fontSize: 10, weight: .medium)
    let locationIcon = UIImageView()
    let locationLabel = TravelPlannerSubTitleLabel(fontSize: 8, weight: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with destination: Destination) {
        if !destination.image.isEmpty {
            imageView.image = UIImage(named: destination.image)
        } else {
            imageView.image = UIImage(named: "image_placeholder")
        }
        
        nameLabel.text = destination.name
        priceLabel.text = destination.price
        descriptionLabel.text = destination.description
        locationLabel.text = destination.locationName
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(hex: "#4A4A93")
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        contentView.addSubviews(imageView, nameLabel, priceLabel, descriptionLabel, locationIcon, locationLabel)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-50)
        }
        nameLabel.textColor = UIColor.init(hex: "#362E83")
        
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.trailing.equalToSuperview().offset(-10)
        }
        priceLabel.textColor = UIColor.init(hex: "#362E83")
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(6)
        }
        descriptionLabel.numberOfLines = 3
        descriptionLabel.lineBreakMode = .byTruncatingTail
        
        locationIcon.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.height.equalTo(16)
        }
        locationIcon.image = UIImage(systemName: "mappin.and.ellipse")
        locationIcon.contentMode = .scaleAspectFit
        locationIcon.tintColor = UIColor.init(hex: "#362E83")
        
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationIcon)
            make.leading.equalTo(locationIcon.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
        locationLabel.textColor = UIColor.init(hex: "#362E83")
    }
}
