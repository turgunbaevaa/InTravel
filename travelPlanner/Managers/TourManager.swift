//
//  TourManager.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 21/1/25.
//

import Foundation
import FirebaseFirestore

class TourManager {
    
    static let shared = TourManager()
    
    func addTour(tour: Tour) {
        let db = Firestore.firestore()
        let tourData: [String: Any] = [
            "name": tour.name,
            "startDate": Timestamp(date: tour.startDate),
            "endDate": Timestamp(date: tour.endDate),
            "location": tour.location,
            "details": tour.details
        ]
        
        db.collection("tour").addDocument(data: tourData) { error in
            if let error = error {
                print("Error adding tour: \(error.localizedDescription)")
            } else {
                print("Tour added successfully!")
            }
        }
    }
    
    func fetchTours(completion: @escaping ([Tour]) -> Void) {
        let db = Firestore.firestore()
        db.collection("tour").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching tours: \(error.localizedDescription)")
                completion([])
            } else {
                let tours = snapshot?.documents.compactMap { doc -> Tour? in
                    let data = doc.data()
                    guard let name = data["name"] as? String,
                          let startDate = (data["startDate"] as? Timestamp)?.dateValue(),
                          let endDate = (data["endDate"] as? Timestamp)?.dateValue(),
                          let location = data["location"] as? String,
                          let details = data["details"] as? String else {
                        return nil
                    }
                    return Tour(id: doc.documentID, name: name, startDate: startDate, endDate: endDate, location: location, details: details)
                } ?? []
                completion(tours)
            }
        }
    }

    func updateTour(tour: Tour) {
        let id = tour.id // No need for a guard statement if id is non-optional
        
        let db = Firestore.firestore()
        let tourData: [String: Any] = [
            "name": tour.name,
            "startDate": Timestamp(date: tour.startDate),
            "endDate": Timestamp(date: tour.endDate),
            "location": tour.location,
            "details": tour.details
        ]
        
        db.collection("tour").document(id).updateData(tourData) { error in
            if let error = error {
                print("Error updating tour: \(error.localizedDescription)")
            } else {
                print("Tour updated successfully!")
            }
        }
    }

    func deleteTour(tourID: String) {
        let db = Firestore.firestore()
        db.collection("tour").document(tourID).delete { error in
            if let error = error {
                print("Error deleting tour: \(error.localizedDescription)")
            } else {
                print("Tour deleted successfully!")
            }
        }
    }

}
