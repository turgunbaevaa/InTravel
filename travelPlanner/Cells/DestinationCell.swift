//
//  DestinationsCollectionViewCell.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 14/1/25.
//

import UIKit

class DestinationCell: UICollectionViewCell {
    let imageView = UIImageView()
    let nameLabel = TravelPlannerSubTitleLabel(fontSize: 10, weight: .semibold)
    let priceLabel = TravelPlannerSubTitleLabel(fontSize: 8, weight: .semibold)
    let descriptionLabel = TravelPlannerSubTitleLabel(fontSize: 8, weight: .medium)
    let locationIcon = UIImageView()
    let locationLabel = TravelPlannerSubTitleLabel(fontSize: 8, weight: .medium)
}
