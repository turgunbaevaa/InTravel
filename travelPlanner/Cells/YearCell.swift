//
//  YearMonthCell.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 18/1/25.
//

import UIKit

class YearCell: UICollectionViewCell {
    static let identifier = "year_cell"
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(yearLabel)
        yearLabel.snp.makeConstraints { make in
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
    
    func configure(year: Int, isSelected: Bool) {
        yearLabel.text = "\(year)"
        contentView.backgroundColor = isSelected ? .orange : .clear
        yearLabel.textColor = isSelected ? .white : .white
    }
}
