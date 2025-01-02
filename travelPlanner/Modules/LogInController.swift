//
//  LogInController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 1/1/25.
//

import UIKit
import SnapKit

class LogInController: UIViewController {
    
    private let signInView = AuthHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(hex: "#362E83")
        
        // Подписываемся на действие кнопки
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
        print("Sign In button tapped")
        let vc = HomeController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false, completion: nil)
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
}
