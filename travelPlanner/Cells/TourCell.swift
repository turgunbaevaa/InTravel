//
//  TourCell.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 16/1/25.
//

import UIKit
import SnapKit

class TourCell: UITableViewCell {
    static let identifier = "tour_cell"
    
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let locationLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel, locationLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(contentView.snp.top).offset(8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tour: Tour) {
        titleLabel.text = tour.name
        dateLabel.text = "\(tour.startDate) - \(tour.endDate)"
        locationLabel.text = tour.location
    }
}
