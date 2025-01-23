//
//  Tour.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 16/1/25.
//

import Foundation
import FirebaseCore

struct Tour {
    let id: String
    let name: String
    let startDate: Date
    let endDate: Date
    let location: String
    let details: String
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "startDate": Timestamp(date: startDate), // Convert Date to Firestore Timestamp
            "endDate": Timestamp(date: endDate),     // Convert Date to Firestore Timestamp
            "location": location,
            "details": details
        ]
    }
    
    init(id: String = UUID().uuidString, name: String, startDate: Date, endDate: Date, location: String, details: String) {
            self.id = id
            self.name = name
            self.startDate = startDate
            self.endDate = endDate
            self.location = location
            self.details = details
        }
}
