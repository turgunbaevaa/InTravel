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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
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
        //contentView.backgroundColor = UIColor(hex: "#362E83")
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    private func setupSubviews() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel, locationLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        guard let stackView = contentView.subviews.first as? UIStackView else { return }
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(contentView.snp.top).offset(8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
    }
    
    func configure(with tour: Tour) {
        titleLabel.text = tour.name

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let startDate = formatter.string(from: tour.startDate)
        let endDate = formatter.string(from: tour.endDate)
        dateLabel.text = "\(startDate) - \(endDate)"

        locationLabel.text = tour.location
    }
}
