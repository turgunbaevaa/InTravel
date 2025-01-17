//
//  AlertManager.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 3/1/25.
//

import UIKit

class AlertManager {
    //MARK: made private as a public
    public static func showBasicAlert(on vc: UIViewController, with title: String, message: String?) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            vc.present(alert, animated: true)
        }
    }
}

//MARK: - Show validation alerts
extension AlertManager {
    
    public static func showInvalidNameAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, with: "Invalid name", message: "Please enter a valid name")
    }
    
    public static func showInvalidSurnameAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, with: "Invalid surname", message: "Please enter a valid surname")
    }
    
    public static func showInvalidEmailAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, with: "Invalid email", message: "Please enter a valid email")
    }
    
    public static func showInvalidPswAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, with: "Invalid password", message: "Please enter a valid password")
    }
    
    public static func showPasswordsDoNotMatchAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, with: "Passwords doesn't match", message: "Please enter a valid password")
    }
}

//MARK: - Refistration alerts
extension AlertManager {
    
    public static func showRegistrationErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, with: "Unknown Registrain Error", message: nil)
    }
    
    public static func showRegistrationErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, with: "Unknown Registrain Error", message: "\(error.localizedDescription)")
    }
}

//MARK: - Log In Errors
extension AlertManager {
    
    public static func showSignInErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, with: "Unknown Error Signing In", message: nil)
    }
    
    public static func showSignInErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, with: "Error Signing In", message: "\(error.localizedDescription)")
    }
}

//MARK: - Log Out Errors
extension AlertManager {
    public static func showLogOutErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, with: "Log Out Error", message: "\(error.localizedDescription)")
    }
}

//MARK: - Forgot Password
extension AlertManager {
    
    public static func showPasswordResetSend(on vc: UIViewController) {
        self.showBasicAlert(on: vc, with: "Password Reset Sent", message: nil)
    }
    
    public static func showErrorSendingPasswordReset(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, with: "Error Sending Password Reset", message: "\(error.localizedDescription)")
    }
}

//MARK: - Fetching User Error
extension AlertManager {
    
    public static func showFetchinUserError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, with: "Error Fetching User", message: "\(error.localizedDescription)")
    }
    
    public static func showUnknownFetchingUserError(on vc: UIViewController) {
        self.showBasicAlert(on: vc, with: "Unknown Error Fetching User", message: nil)
    }
}

extension AlertManager {
    public static func showFirebaseErrorAlert(on vc: UIViewController, message: String) {
        self.showBasicAlert(on: vc, with: "Error", message: message)
    }
}
