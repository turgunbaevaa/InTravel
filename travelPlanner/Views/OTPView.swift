//
//  OTPView.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 11/2/25.
//

import UIKit

class OTPView: UIStackView, UITextFieldDelegate {
    
    var textFields: [UITextField] = []
    var otpCompletion: ((String) -> Void)?
    
    init(digits: Int = 5) {
        super.init(frame: .zero)
        setupStackView()
        setupTextFields(digits: digits)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        setupTextFields(digits: 5)
    }
    
    private func setupStackView() {
        axis = .horizontal
        alignment = .center
        distribution = .fillEqually
        spacing = 8
    }
    
    private func setupTextFields(digits: Int) {
        for _ in 0..<digits {
            let textField = createOTPTextField()
            textFields.append(textField)
            addArrangedSubview(textField)
        }
        textFields.first?.becomeFirstResponder()
    }
    
    private func createOTPTextField() -> UITextField {
        let textField = UITextField()
        textField.delegate = self
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 8
        textField.keyboardType = .numberPad
        textField.isSecureTextEntry = true
        textField.widthAnchor.constraint(equalToConstant: 40).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return textField
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        guard let text = textField.text, text.count == 1 else {
            return
        }
        
        if let index = textFields.firstIndex(of: textField), index < textFields.count - 1 {
            textFields[index + 1].becomeFirstResponder()
        }
        
        let otpCode = textFields.compactMap { $0.text }.joined()
        if otpCode.count == textFields.count {
            otpCompletion?(otpCode)
        }
    }
    
    func clear() {
        textFields.forEach { $0.text = "" }
        textFields.first?.becomeFirstResponder()
    }
}
