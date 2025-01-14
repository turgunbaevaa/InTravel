//
//  ForgotPasswordController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 1/1/25.
//

import UIKit

class ForgotPasswordController: UIViewController {
    
    private let forgotPswView = ForgotPswView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(hex: "#362E83")
        
        forgotPswView.onNextTapped = { [weak self] in
            self?.handleNext()
        }
        setupUI()
        setupBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupUI() {
        view.addSubview(forgotPswView)
        forgotPswView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(310)
        }
    }
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapBack))
        backButton.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func handleNext() {
        let email = forgotPswView.getEmailText() ?? ""
        
        if !Validator.isValidEmail(for: email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        AuthService.shared.forgotPassword(with: email) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showErrorSendingPasswordReset(on: self, with: error)
                return
            }
            
            AlertManager.showPasswordResetSend(on: self)
        }
    }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}
