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
        
        // Подписываемся на действие кнопки
        forgotPswView.onNextTapped = { [weak self] in
            self?.handleNext()
        }
        setupUI()
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
    
    private func handleNext() {
        print("Next button tapped")
        //        let vc = ForgotPasswordController()
        //        navigationController?.pushViewController(vc, animated: true)
        guard let email = forgotPswView.getEmailText(), !email.isEmpty else {
            print("Email field is empty")
            return
        }
    }
}
