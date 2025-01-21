//
//  TravelPlannerTitleLabel.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 1/1/25.
//

import UIKit

class TravelPlannerTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fontSize: CGFloat, weight: UIFont.Weight) {
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: weight)
    }
    
    private func configure() {
        textColor = .init(hex: "#362E83")
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
    }
    
}
