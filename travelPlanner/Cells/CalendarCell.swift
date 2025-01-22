//
//  CalendarCell.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 16/1/25.
//

import UIKit
import SnapKit

class CalendarCell: UICollectionViewCell {
    static let identifier = "calendar_cell"

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with date: Date?, calendar: Calendar, isToday: Bool, isTourDate: Bool, isSelected: Bool) {
        guard let date = date else {
            contentView.backgroundColor = .clear
            dateLabel.text = ""
            return
        }

        let day = calendar.component(.day, from: date)
        dateLabel.text = "\(day)"
        dateLabel.textAlignment = .center

        if isSelected {
            contentView.backgroundColor = .orange
            dateLabel.textColor = .white
        } else if isToday {
            contentView.backgroundColor = .blue
            dateLabel.textColor = .white
        } else if isTourDate {
            contentView.backgroundColor = .orange
            dateLabel.textColor = .white
        } else {
            contentView.backgroundColor = .clear
            dateLabel.textColor = .white
        }
    }
}
