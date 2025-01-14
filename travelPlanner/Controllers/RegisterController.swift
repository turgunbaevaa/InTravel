//
//  RegisterController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 1/1/25.
//

import UIKit

class RegisterController: UIViewController {
    
    private let signUpView = SignUpView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(hex: "#362E83")
        
        signUpView.onSignInTapped = { [weak self] in
            self?.handleSignIn()
        }
        
        signUpView.onSignUpTapped = { [weak self] in
            self?.handleSignUp()
        }
        
        signUpView.onLinkTapped = { [weak self] urlString in
            self?.showWebViewer(with: urlString)
        }
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        view.addSubview(signUpView)
        signUpView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(115)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(75)
        }
    }
    
    //MARK: Validate all the fields
    
    private func validateFields(for request: RegisterUserRequest) -> String? {
        if !Validator.isValidName(for: request.name) {
            return "Invalid name. Please enter a valid name (4-24 characters)."
        }
        if !Validator.isValidSurname(for: request.surname) {
            return "Invalid surname. Please enter a valid surname (4-24 characters)."
        }
        if !Validator.isValidEmail(for: request.email) {
            return "Invalid email. Please enter a valid email address."
        }
        if !Validator.isPasswordValid(for: request.password) {
            return "Invalid password. Password must contain at least one uppercase letter, one special character, and be 6-32 characters long."
        }
        if request.password != request.confPassword {
            return "Passwords do not match. Please ensure both passwords are the same."
        }
        return nil
    }
    
    private func handleSignUp() {
        let registerUserRequest = RegisterUserRequest(
            name: signUpView.getName() ?? "",
            surname: signUpView.getSurname() ?? "",
            email: signUpView.getEmail() ?? "",
            password: signUpView.getPassword() ?? "",
            confPassword: signUpView.getConfirmPassword() ?? ""
        )
        
        // Validate all fields
        if let validationError = validateFields(for: registerUserRequest) {
            AlertManager.showBasicAlert(on: self, with: "Validation Error", message: validationError)
            return
        }
        
        // Proceed with registration
        AuthService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
            guard let self = self else { return }
            
            if let error {
                AlertManager.showRegistrationErrorAlert(on: self, with: error)
                return
            }
            
            if wasRegistered {
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            } else {
                AlertManager.showRegistrationErrorAlert(on: self)
            }
        }
    }
    
    private func handleSignIn() {
        print("Sign In button tapped")
        let vc = LogInController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showWebViewer(with urlString: String) {
        let vc = WebViewerController(with: urlString)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
}
