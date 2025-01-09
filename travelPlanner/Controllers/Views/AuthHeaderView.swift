//
//  AuthHeaderView.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 1/1/25.
//

import UIKit
import SnapKit

class AuthHeaderView: UIView {
    
    var onSignInTapped: (() -> Void)?
    
    var onForgotPswTapped: (() -> Void)?
    
    var onSignUpTapped: (() -> Void)?
        
    // MARK: - UI Components
    private let mainTitle = TravelPlannerTitleLabel(fontSize: 28, 
                                                    weight: .bold)
    
    private let subTitle = TravelPlannerSubTitleLabel(fontSize: 20, 
                                                      weight: .regular)
    
    private let emailField = TravelPlannerTextField(placeholder: "Email")
    
    private let pswField = TravelPlannerTextField(placeholder: "Password")
    
    private let signInBtn = TravelPlannerButton(backgroundColor: .init(hex: "#362E83"), 
                                                titleColor: .white,
                                                title: "Sign in")
    
    private let forgotBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot Password?", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.init(hex: "#33415C"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return button
    }()
    
    private let signUpBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Don't have an account? Sign Up", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor.init(hex: "#33415C"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return button
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
        addSubviews(mainTitle, subTitle, emailField, pswField, signInBtn, forgotBtn, signUpBtn)
        
        mainTitle.text = "Let’s plan trips with Travel Planner!"
        mainTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview().inset(18)
        }
        
        subTitle.text = "Discover the World with Every Sign In"
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(mainTitle.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(18)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(11)
            make.height.equalTo(48)
        }
        emailField.keyboardType = .emailAddress
        emailField.textContentType = .emailAddress 
        
        pswField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(11)
            make.height.equalTo(48)
        }
        pswField.textContentType = .oneTimeCode
        pswField.isSecureTextEntry = true
        
        forgotBtn.snp.makeConstraints { make in
            make.top.equalTo(pswField.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-14)
        }
        forgotBtn.addTarget(self, action: #selector(didTapForgotPsw), for: .touchUpInside)
        
        signInBtn.snp.makeConstraints { make in
            make.top.equalTo(forgotBtn.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(11)
            make.height.equalTo(48)
        }
        signInBtn.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
        signUpBtn.snp.makeConstraints { make in
            make.top.equalTo(signInBtn.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
        }
        signUpBtn.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc private func didTapForgotPsw() {
        onForgotPswTapped?()
    }
    
    @objc private func didTapSignIn() {
        onSignInTapped?()
    }
    
    @objc private func didTapSignUp() {
        onSignUpTapped?()
    }

}
