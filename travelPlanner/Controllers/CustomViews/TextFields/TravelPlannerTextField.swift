//
//  TravelPlannerTextField.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 1/1/25.
//

import UIKit

class TravelPlannerTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String) {
        self.init(frame: .zero)
        set(placeholder: placeholder)
    }
    
    private func configure() {
        layer.cornerRadius = 10
        layer.backgroundColor = UIColor.white.cgColor
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.init(hex: "#362E83").cgColor
        
        textColor = .label
        tintColor = .label
        textAlignment = .left
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 16
        
        backgroundColor = .white
        autocorrectionType = .no
        returnKeyType = .go
        clearButtonMode = .whileEditing
        
        // Добавляем отступ для плейсхолдера
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        leftView = padding
        leftViewMode = .always
    }
    
    func set(placeholder: String){
        self.placeholder = placeholder
    }
}
