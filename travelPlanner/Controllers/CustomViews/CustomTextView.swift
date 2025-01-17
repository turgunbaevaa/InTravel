//
//  CustomTextView.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 18/1/25.
//

import UIKit

class CustomTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        font = UIFont.systemFont(ofSize: 16)
        backgroundColor = UIColor(hex: "#362E83")
        textColor = .white
        layer.cornerRadius = 8
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    }
}
