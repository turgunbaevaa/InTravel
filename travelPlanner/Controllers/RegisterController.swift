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
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isHidden = true
//    }
    
    private func setupUI() {
        view.addSubview(signUpView)
        signUpView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(115)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(75)
        }
    }
    
    private func handleSignUp() {
        print("Sign Up button tapped")
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
    
//    func textViewDidChangeSelection(_ textView: UITextView) {
//        textView.delegate = nil
//        textView.selectedTextRange = nil
//        textView.delegate = self
//    }
}
