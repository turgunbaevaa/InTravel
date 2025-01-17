//
//  CustomTextField.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 18/1/25.
//

import UIKit

class CustomTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        setPadding(10)
        setPlaceholder("Enter text here", color: .lightGray)
    }
    
    func setPlaceholder(_ text: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
    
    private func setPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
