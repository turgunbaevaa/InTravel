//
//  TourManager.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 21/1/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class TourManager {
    
    static let shared = TourManager()
    
    func addTour(tour: Tour) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        let db = Firestore.firestore()
        let tourData: [String: Any] = [
            "userUID": userUID,
            "name": tour.name,
            "startDate": Timestamp(date: tour.startDate),
            "endDate": Timestamp(date: tour.endDate),
            "location": tour.location,
            "details": tour.details
        ]
        
        db.collection("tours").document(tour.id).setData(tourData, merge: true) { error in
            if let error = error {
                print("Error adding tour: \(error.localizedDescription)")
            } else {
                print("Tour added successfully!")
            }
        }
    }
    
    func fetchTours(completion: @escaping ([Tour]) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            completion([])
            return
        }

        let db = Firestore.firestore()
        db.collection("tours")
            .whereField("userUID", isEqualTo: userUID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Firestore Error fetching tours:", error.localizedDescription)
                    completion([])
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No tours found in Firestore")
                    completion([])
                    return
                }

                let tours = documents.compactMap { doc -> Tour? in
                    let data = doc.data()
                    print("Fetched Tour Data:", data)

                    //Ensure `startDate` and `endDate` exist
                    guard let startDateTimestamp = data["startDate"] as? Timestamp,
                          let endDateTimestamp = data["endDate"] as? Timestamp else {
                        print("Missing `startDate` or `endDate` in document:", doc.documentID)
                        return nil
                    }

                    let startDate = startDateTimestamp.dateValue()
                    let endDate = endDateTimestamp.dateValue()

                    //Prevent NaN issues
                    if startDate.timeIntervalSince1970.isNaN || endDate.timeIntervalSince1970.isNaN {
                        print("Invalid date detected in document:", doc.documentID)
                        return nil
                    }

                    //Ensure all required fields exist
                    guard let name = data["name"] as? String,
                          let location = data["location"] as? String,
                          let details = data["details"] as? String else {
                        print("Invalid document format in Firestore:", doc.documentID)
                        return nil
                    }

                    return Tour(
                        id: doc.documentID,
                        name: name,
                        startDate: startDate,
                        endDate: endDate,
                        location: location,
                        details: details,
                        userUID: userUID
                    )
                }

                DispatchQueue.main.async {
                    completion(tours)
                }
            }
    }
    
    func updateTour(tour: Tour) {
        let db = Firestore.firestore()
        let tourData: [String: Any] = [
            "name": tour.name,
            "startDate": Timestamp(date: tour.startDate),
            "endDate": Timestamp(date: tour.endDate),
            "location": tour.location,
            "details": tour.details,
            "userUID": tour.userUID
        ]
        
        db.collection("tours").document(tour.id).updateData(tourData) { error in
            if let error = error {
                if (error as NSError).domain == FirestoreErrorDomain,
                   (error as NSError).code == FirestoreErrorCode.notFound.rawValue {
                    print("Document not found: \(tour.id)")
                } else {
                    print("Error updating tour: \(error.localizedDescription)")
                }
            } else {
                print("Tour updated successfully!")
            }
        }
    }
    
    func deleteTour(tourID: String) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Firestore Delete Error: User UID is nil!")
            return
        }
        
        print("User UID: \(userUID) - Attempting to delete tour with ID: \(tourID)")
        
        let db = Firestore.firestore()
        let docRef = db.collection("tours").document(tourID)
        
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Firestore Error fetching document before delete:", error.localizedDescription)
                return
            }
            
            guard let document = document, document.exists else {
                print("Tour document not found! Cannot delete.")
                return
            }
            
            let data = document.data()
            print("Tour Data Before Delete:", data ?? "No data found")
            
            let ownerUID = data?["userUID"] as? String ?? ""
            
            if ownerUID == userUID {
                docRef.delete { error in
                    if let error = error {
                        print("Firestore Delete Error:", error.localizedDescription)
                    } else {
                        print("Tour deleted successfully!")
                    }
                }
            } else {
                print("Permission denied: You can only delete your own tours!")
            }
        }
    }
}
