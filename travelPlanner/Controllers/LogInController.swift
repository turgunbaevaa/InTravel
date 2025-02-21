//
//  LogInController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 1/1/25.
//

import UIKit
import SnapKit

class LogInController: UIViewController {
    
    private let signInView = SignInView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(hex: "#362E83")
        
        signInView.onForgotPswTapped = { [weak self] in
            self?.handleForgotPsw()
        }
        
        signInView.onSignInTapped = { [weak self] in
            self?.handleSignIn()
        }
        
        signInView.onSignUpTapped = { [weak self] in
            self?.handleSignUp()
        }
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        view.addSubview(signInView)
        signInView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(115)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(140)
        }
    }
    
    private func handleSignIn() {
        let loginUserRequest = LogInUserRequest(
            email: signInView.getRegisteredEmail() ?? "",
            password: signInView.getRegisteredPassword() ?? ""
        )
        
        if !Validator.isValidEmail(for: loginUserRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        if !Validator.isPasswordValid(for: loginUserRequest.password) {
            AlertManager.showInvalidPswAlert(on: self)
            return
        }
        
        AuthService.shared.signIn(with: loginUserRequest) { [weak self] errorMessage in
            guard let self = self else { return }
            
            if let errorMessage {
                AlertManager.showBasicAlert(on: self, with: "Sign-In Error", message: errorMessage)
                return
            }
            
            self.requestOTP()
        }
    }
    
    private func handleForgotPsw() {
        print("Forgot Password button tapped")
        let vc = ForgotPasswordController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignUp() {
        print("Sign Up button tapped")
        let vc = RegisterController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func requestOTP() {
        guard let email = signInView.getRegisteredEmail() else { return }
        
        APIManager.sendOTP(email: email) { success in
            DispatchQueue.main.async {
                if success {
                    let otpVC = OTPController(email: email)
                    self.navigationController?.pushViewController(otpVC, animated: true)
                } else {
                    let alert = UIAlertController(title: "Failed to Send OTP", message: "Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
