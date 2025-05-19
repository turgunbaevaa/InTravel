//
//  APIManager.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 11/2/25.
//

import Foundation
/*
class APIManager {
    static let serverURL = "http://192.168.1.168:3000"
    
    static func registerUser(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "\(serverURL)/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error registering user: \(error)")
                completion(false, "Network error")
                return
            }
            if let data = data,
               let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let success = jsonResponse["success"] as? Bool {
                let message = jsonResponse["message"] as? String
                completion(success, message)
            } else {
                completion(false, "Unexpected error")
            }
        }
        task.resume()
    }
    
    static func loginUser(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "\(serverURL)/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error logging in: \(error)")
                completion(false, "Network error")
                return
            }
            if let data = data,
               let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let success = jsonResponse["success"] as? Bool {
                let message = jsonResponse["message"] as? String
                completion(success, message)
            } else {
                completion(false, "Unexpected error")
            }
        }
        task.resume()
    }
    
    
    static func sendOTP(email: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(serverURL)/send-otp")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending OTP: \(error)")
                completion(false)
                return
            }
            if let data = data,
               let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let success = jsonResponse["success"] as? Bool {
                completion(success)
            } else {
                completion(false)
            }
        }
        task.resume()
    }
    
    static func verifyOTP(email: String, otp: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(serverURL)/verify-otp")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": email, "otp": otp]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error verifying OTP:", error.localizedDescription)
                completion(false)
                return
            }
            if let data = data,
               let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let success = jsonResponse["success"] as? Bool {
                completion(success)
            } else {
                completion(false)
            }
        }
        task.resume()
    }
}
*/
