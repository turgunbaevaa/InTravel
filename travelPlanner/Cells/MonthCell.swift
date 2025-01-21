//
//  MonthCell.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 18/1/25.
//

import UIKit

class MonthCell: UICollectionViewCell {
    static let identifier = "month_cell"
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(monthLabel)
        monthLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(month: String, isSelected: Bool) {
        monthLabel.text = month
        contentView.backgroundColor = isSelected ? .orange : .clear
        monthLabel.textColor = isSelected ? .white : .white
    }
}

