//
//  AuthService.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 1/1/25.
//

import Foundation

class AuthService {
    
    public static let shared = AuthService()
    
    private init() {}
    
    public func registerUser(with userRequest: RegisterUserRequest, 
                             completion: @escaping (Bool, Error?)-> Void) {
        
    }
}


