//
//  OTPController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 11/2/25.
//

import UIKit
import SnapKit
import FirebaseAuth

class OTPController: UIViewController {
    
    private let email: String
    let otpView = OTPView(digits: 6)
    let confirmButton = TravelPlannerButton(backgroundColor: UIColor.init(hex: "#362E83"),
                                            titleColor: UIColor.init(hex: "#FFFFFF"),
                                            title: "Confirm")
    let infoLabel = TravelPlannerSubTitleLabel(fontSize: 16, weight: .semibold)
    
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        otpView.otpCompletion = { [weak self] otp in
            self?.confirmOTP(otp)
        }
        view.addSubviews(infoLabel, otpView, confirmButton)
        
        infoLabel.text = "We have sent an SMS to your email with a 6-digit code."
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 2
        
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        otpView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(otpView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }
    
    @objc private func confirmTapped() {
        let otpCode = otpView.textFields.compactMap { $0.text }.joined()
        confirmOTP(otpCode)
    }
    
    private func confirmOTP(_ otp: String) {
        APIManager.verifyOTP(email: email, otp: otp) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    print("OTP Verified Successfully")
                    
                    // Ensure Firebase user session is reloaded
                    Auth.auth().currentUser?.reload(completion: { error in
                        if let error = error {
                            print("Firebase session reload failed:", error.localizedDescription)
                        } else {
                            print("Firebase session reloaded")
                            self?.goToHomeScreen()
                        }
                    })
                } else {
                    let alert = UIAlertController(title: "Invalid OTP", message: "Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    private func goToHomeScreen() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate else { return }

        let mainTabBarController = TabBarController()
        delegate.window?.rootViewController = mainTabBarController
        delegate.window?.makeKeyAndVisible()
    }
}
