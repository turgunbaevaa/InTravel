//
//  TourDetailsController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 22/1/25.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class TourDetailsController: UIViewController {

    weak var delegate: EditTourDelegate?
    var tour: Tour?
    
    private let detailsView = TourDetailsView()

    override func loadView() {
        view = detailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let tour = tour else {
            print("Tour is nil") // Handle this case better later
            return
        }

        detailsView.configure(with: tour)
        detailsView.setEditButtonTarget(self, action: #selector(editButtonTapped))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let tourID = tour?.id else { return }

        let db = Firestore.firestore()
        db.collection("tours").document(tourID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching updated tour: \(error.localizedDescription)")
            } else if let data = snapshot?.data() {
                guard let name = data["name"] as? String,
                      let startDate = (data["startDate"] as? Timestamp)?.dateValue(),
                      let endDate = (data["endDate"] as? Timestamp)?.dateValue(),
                      let location = data["location"] as? String,
                      let details = data["details"] as? String,
                      let userUID = data["userUID"] as? String else { 
                    return
                }

                let updatedTour = Tour(
                    id: tourID,
                    name: name,
                    startDate: startDate,
                    endDate: endDate,
                    location: location,
                    details: details,
                    userUID: userUID
                )

                self.tour = updatedTour
                self.detailsView.configure(with: updatedTour)
            }
        }
    }
    
    @objc private func editButtonTapped() {
        let editController = EditTourController()
        editController.tour = tour
        editController.delegate = self 
        navigationController?.pushViewController(editController, animated: true)
    }
}

extension TourDetailsController: EditTourDelegate {
    func tourDidUpdate(_ updatedTour: Tour) {
        self.tour = updatedTour
        detailsView.configure(with: updatedTour)
        delegate?.tourDidUpdate(updatedTour)
    }

    func tourDidDelete(_ deletedTourID: String) {
        delegate?.tourDidDelete(deletedTourID) 
        navigationController?.popViewController(animated: true) // Go back
    }
}
