//
//  TourDetailsController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 22/1/25.
//

import UIKit

class TourDetailsController: UIViewController {

    var tour: Tour?
    
    private let detailsView = TourDetailsView()

    override func loadView() {
        view = detailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let tour = tour else {
            print("Tour is nil") // Handle this case better
            return
        }

        detailsView.configure(with: tour)
        detailsView.setEditButtonTarget(self, action: #selector(editButtonTapped))
    }


    @objc private func editButtonTapped() {
        let editController = EditTourController()
        editController.tour = tour
        navigationController?.pushViewController(editController, animated: true)
    }
}
