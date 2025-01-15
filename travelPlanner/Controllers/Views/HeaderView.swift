//
//  HeaderView.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 15/1/25.
//

import UIKit
import SnapKit

class HeaderView: UICollectionReusableView {
    
    static let reuseId = "header_view"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
