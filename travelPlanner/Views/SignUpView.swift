//
//  SignUpView.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 2/1/25.
//

import UIKit

class SignUpView: UIView {
    
    var onSignUpTapped: (() -> Void)?
    
    var onSignInTapped: (() -> Void)?
    
    var onLinkTapped: ((String) -> Void)?
    
    // MARK: - UI Components
    private let mainTitle = TravelPlannerTitleLabel(fontSize: 28,
                                                    weight: .bold)
    
    private let subTitle = TravelPlannerSubTitleLabel(fontSize: 20,
                                                      weight: .regular)
    
    private let nameField = TravelPlannerTextField(placeholder: "Name")
    
    private let surnameField = TravelPlannerTextField(placeholder: "Surname")
    
    private let emailField = TravelPlannerTextField(placeholder: "Email")
    
    private let pswField = TravelPlannerTextField(placeholder: "Password")
    
    private let confPswField = TravelPlannerTextField(placeholder: "Confirm Password")
    
    private let signUpBtn = TravelPlannerButton(backgroundColor: .init(hex: "#362E83"),
                                                titleColor: .white,
                                                title: "Sign Up")
    
    private let signInBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Already have an account? Sign In", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.init(hex: "#33415C"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return button
    }()
    
    private let termsTextView: UITextView = {
        let attributedString = NSMutableAttributedString(string: "By creating an account, you agree to our Terms & Conditions and you acknowledge that you have read our Privacy Policy")
        attributedString.addAttribute(.link, value: "terms://termsAndConditions", range: (attributedString.string as NSString).range(of: "Terms & Conditions"))
        
        attributedString.addAttribute(.link, value: "privacy://privacyPolicy", range: (attributedString.string as NSString).range(of: "Privacy Policy"))
        
        let textView = UITextView()
        textView.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        textView.backgroundColor = .clear
        textView.attributedText = attributedString
        textView.textColor = .label
        textView.isSelectable = true
        textView.isEditable = false
        textView.delaysContentTouches = false
        textView.isScrollEnabled = false
        textView.textAlignment = .center
        return textView
    }()
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func configure() {
        addSubviews(mainTitle, subTitle, nameField, surnameField, emailField, pswField, confPswField, signUpBtn, signInBtn, termsTextView)
        
        mainTitle.text = "Let’s plan trips with Travel Planner!"
        mainTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview().inset(18)
        }
        
        subTitle.text = "Discover the World with Every Sign Up"
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(mainTitle.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(18)
        }
        
        nameField.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(11)
            make.height.equalTo(48)
        }
        
        surnameField.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(11)
            make.height.equalTo(48)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(surnameField.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(11)
            make.height.equalTo(48)
        }
        emailField.keyboardType = .emailAddress
        emailField.textContentType = .emailAddress
        emailField.addTarget(self, action: #selector(emailFieldEditingChanged(_:)), for: .editingChanged)
        
        pswField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(11)
            make.height.equalTo(48)
        }
        pswField.textContentType = .oneTimeCode
        pswField.isSecureTextEntry = true
        
        confPswField.snp.makeConstraints { make in
            make.top.equalTo(pswField.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(11)
            make.height.equalTo(48)
        }
        confPswField.textContentType = .oneTimeCode
        confPswField.isSecureTextEntry = true
        
        signUpBtn.snp.makeConstraints { make in
            make.top.equalTo(confPswField.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(11)
            make.height.equalTo(48)
        }
        signUpBtn.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        
        termsTextView.snp.makeConstraints { make in
            make.top.equalTo(signUpBtn.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(11)
        }
        termsTextView.delegate = self
        
        signInBtn.snp.makeConstraints { make in
            make.top.equalTo(termsTextView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(11)
        }
        signInBtn.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
    }
    
    // MARK: - Selectors
    @objc private func emailFieldEditingChanged(_ textField: UITextField) {
        textField.text = textField.text?.lowercased()
    }

    @objc private func didTapSignUp() {
        onSignUpTapped?()
    }
    
    @objc private func didTapSignIn() {
        onSignInTapped?()
    }
    
    func getName() -> String? {
        return nameField.text
    }
    
    func getSurname() -> String? {
        return surnameField.text
    }
    
    func getEmail() -> String? {
        return emailField.text
    }
    
    func getPassword() -> String? {
        return pswField.text
    }
    
    func getConfirmPassword() -> String? {
        return confPswField.text
    }
}

extension SignUpView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "terms" {
            onLinkTapped?("https://policies.google.com/terms?hl=en-US")
        } else if URL.scheme == "privacy" {
            onLinkTapped?("https://policies.google.com/privacy?hl=en-US")
        }
        return false
    }
}
