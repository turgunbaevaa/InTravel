//
//  HomeController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 1/1/25.
//

import UIKit
import SnapKit

class HomeController: UIViewController {
    
    //MARK: - UI Components
    
    private let homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupHomeView()
        
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let self = self else { return }
            
            if let error = error {
                AlertManager.showFetchinUserError(on: self, with: error)
                return
            }
            
            if let user = user {
                DispatchQueue.main.async {
                    self.homeView.updateGreeting(with: user.name)
                }
            }
        }
    }
    
    //MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.init(hex: "#362E83")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right")?.withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(didTapLogout)
        )

        // Set the tintColor to white for the bar button item
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func setupHomeView() {
        
        view.addSubview(homeView)
        
        homeView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16) // Corrected this line
            make.leading.trailing.equalToSuperview()
        }
        
        homeView.searchTextField.delegate = self
    }
    
    @objc private func didTapLogout() {
        AuthService.shared.signOut { [weak self] error in
            guard let self else { return }
            
            if let error = error {
                AlertManager.showLogOutErrorAlert(on: self, with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
}

extension HomeController: UITextFieldDelegate {
    // UITextFieldDelegate: Handle text changes
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        print("Search query: \(updatedText)")
        // Here, you can filter your data or update the UI
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("Search submitted: \(textField.text ?? "")")
        return true
    }
}
