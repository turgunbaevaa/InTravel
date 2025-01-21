//
//  NetworkManager.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 15/1/25.
//

import FirebaseFirestore

class NetworkManager {
    
    static let shared = NetworkManager() 
    
    private init() {}
    
    func fetchDestinations(completion: @escaping ([Destination]?, Error?) -> Void) {
        let db = Firestore.firestore()
        var allDestinations: [Destination] = []
        
        // Fetch "Places"
        db.collection("destinations").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching places:", error.localizedDescription)
                completion(nil, error) // Return error
                return
            }
            
            if let documents = snapshot?.documents {
                let places = documents.compactMap { try? $0.data(as: Destination.self) }
                allDestinations.append(contentsOf: places)
            }
            
            // Fetch "Hotels"
            db.collection("hotels").getDocuments { snapshot, error in
                if let error = error {
                    completion(nil, error) // Return error
                    return
                }
                
                if let documents = snapshot?.documents {
                    let hotels = documents.compactMap { try? $0.data(as: Destination.self) }
                    allDestinations.append(contentsOf: hotels)
                }
                
                // Return combined data via completion handler
                completion(allDestinations, nil)
            }
        }
    }
}
