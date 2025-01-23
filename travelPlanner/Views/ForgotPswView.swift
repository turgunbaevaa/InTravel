//
//  ForgotPswView.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 2/1/25.
//

import UIKit
import SnapKit

class ForgotPswView: UIView {

    var onNextTapped: (() -> Void)?
    
    // MARK: - UI Components
    private let mainTitle = TravelPlannerTitleLabel(fontSize: 24,
                                                    weight: .bold)
    
    private let subTitle = TravelPlannerSubTitleLabel(fontSize: 16,
                                                      weight: .regular)
    
    private let emailField = TravelPlannerTextField(placeholder: "Email")
    
    private let nextBtn = TravelPlannerButton(backgroundColor: .init(hex: "#362E83"),
                                                titleColor: .white,
                                                title: "Next")
    
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
        addSubviews(mainTitle, subTitle, emailField, nextBtn)
        
        mainTitle.text = "Forgot your password?"
        mainTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(42)
            make.leading.trailing.equalToSuperview().inset(18)
        }
        
        subTitle.text = "Provide your account’s email for which you want to reset your password!"
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(mainTitle.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(18)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(11)
            make.height.equalTo(48)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(11)
            make.height.equalTo(48)
        }
        nextBtn.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        
    }
    
    // MARK: - Selectors
    @objc private func didTapNext() {
        onNextTapped?()
    }
    
    func getEmailText() -> String? {
        return emailField.text
    }
}
