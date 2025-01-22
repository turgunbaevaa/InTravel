//
//  EditTourController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 22/1/25.
//

import UIKit

class EditTourController: UIViewController {

    var tour: Tour?

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
    }
}
