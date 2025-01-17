//
//  AuthService.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 1/1/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    public static let shared = AuthService()
    
    private init() {}
    
    /// A method to register the user
    /// - Parameters:
    ///   - userRequest: users information (name, surname, email, password)
    ///   - completion: A completion with 2 values...
    ///   - Bool: wasRegistered - Determines if the user was registered and saved in the database correctly
    ///   - Error?: An optional error if firebase provides once
    public func registerUser(with userRequest: RegisterUserRequest,
                             completion: @escaping (Bool, Error?)-> Void) {
        let name = userRequest.name
        let surname = userRequest.surname
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                completion(false, error)
                return
            }
            
            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }
            
            let db = Firestore.firestore()
            db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "name": name,
                    "surname": surname,
                    "email": email
                ]) { error in
                    if let error {
                        completion(false, error)
                        return
                    }
                    completion(true, nil)
                }
        }
    }
    
    public func signIn(with userRequest: LogInUserRequest, completion: @escaping (Error?)-> Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    public func signOut(completion: @escaping (Error?)-> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    public func forgotPassword(with email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    public func fetchUser(completion: @escaping (User?, Error?) -> Void) {
        guard let userUID  = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let snapshot = snapshot,
                   let snapshotData = snapshot.data(),
                   let username = snapshotData["name"] as? String {
                    let user = User(name: username, userUID: userUID)
                    completion(user, nil)
                }
            }
    }
}

extension AuthService {
    private func mapFirebaseError(_ error: NSError) -> String {
        switch error.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return "Invalid email format. Please enter a valid email address."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "This email is already in use. Please try signing in or use another email."
        case AuthErrorCode.userNotFound.rawValue:
            return "No account found with this email. Please check your email or sign up."
        case AuthErrorCode.wrongPassword.rawValue:
            return "The password you entered is incorrect. Please try again."
        case AuthErrorCode.weakPassword.rawValue:
            return "Password is too weak. It must be at least 6 characters long."
        default:
            return "An unknown error occurred. Please try again."
        }
    }
    
    public func signIn(with userRequest: LogInUserRequest, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
            if let error = error as NSError? {
                let userFriendlyMessage = self.mapFirebaseError(error)
                completion(userFriendlyMessage)
                return
            }
            completion(nil)
        }
    }
}
