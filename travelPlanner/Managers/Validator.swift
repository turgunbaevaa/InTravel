//
//  Validator.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 4/1/25.
//

import Foundation

class Validator {
    static func isValidEmail(for email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidName(for name: String) -> Bool {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let nameRegEx = "\\w{4,24}"
        let namePred = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: name)
    }
    
    static func isValidSurname(for surname: String) -> Bool {
        let surname = surname.trimmingCharacters(in: .whitespacesAndNewlines)
        let surnameRegEx = "\\w{4,24}"
        let surnamePred = NSPredicate(format: "SELF MATCHES %@", surnameRegEx)
        return surnamePred.evaluate(with: surname)
    }
    
    static func isPasswordValid(for password: String) -> Bool {
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[$@$#!%*?&]).{6,32}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    static func doPasswordsMatch(_ password: String, _ confirmPassword: String) -> Bool {
        return password == confirmPassword
    }
}
