//
//  EditTourController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 22/1/25.
//

import UIKit
import FirebaseAuth

protocol EditTourDelegate: AnyObject {
    func tourDidUpdate(_ updatedTour: Tour)
    func tourDidDelete(_ deletedTourID: String)
}

class EditTourController: UIViewController {

    var tour: Tour?
    weak var delegate: EditTourDelegate? 

    private let editView = EditTourView()

    override func loadView() {
        view = editView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let tour = tour else {
            print("Tour is nil")
            return
        }

        editView.configure(with: tour)
        editView.setUpdateButtonTarget(self, action: #selector(updateButtonTapped))
        editView.setDeleteButtonTarget(self, action: #selector(deleteButtonTapped))
    }
    
    @objc private func updateButtonTapped() {
        guard let tour = tour else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let startDate = formatter.date(from: editView.startDateField.text ?? "") ?? tour.startDate
        let endDate = formatter.date(from: editView.endDateField.text ?? "") ?? tour.endDate

        guard let userUID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        let updatedTour = Tour(
            id: tour.id,
            name: editView.tourNameField.text ?? tour.name,
            startDate: startDate,
            endDate: endDate,
            location: editView.locationField.text ?? tour.location,
            details: editView.remarksField.text ?? tour.details,
            userUID: userUID // Provide the correct userUID
        )

        TourManager.shared.updateTour(tour: updatedTour)

        delegate?.tourDidUpdate(updatedTour)

        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteButtonTapped() {
        guard let tourID = tour?.id else { return }

        TourManager.shared.deleteTour(tourID: tourID)

        delegate?.tourDidDelete(tourID)

        navigationController?.popViewController(animated: true)
    }
}
