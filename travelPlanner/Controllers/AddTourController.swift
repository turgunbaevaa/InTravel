//
//  AddTourController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 17/1/25.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol AddTourDelegate: AnyObject {
    func didAddTour(_ tour: Tour)
}

class AddTourController: UIViewController {
    
    weak var delegate: AddTourDelegate?
    var userUID: String?
    
    private let addTourView = AddTourView()
    private let db = Firestore.firestore()
    private let selectedMonth = Date()
    private let calendarManager = CalendarManager()
    private var tours: [Tour] = []
    var selectedDate: Date?
    
    override func loadView() {
        view = addTourView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        configureCalendar()
    }
    
    private func configureCalendar() {
        addTourView.calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
        addTourView.calendarView.dataSource = self
        addTourView.calendarView.delegate = self
    }
    
    private func setupActions() {
        addTourView.saveButton.addTarget(self, action: #selector(saveTourButtonTapped), for: .touchUpInside)
    }
    
    @objc private func saveTourButtonTapped() {
        guard let name = addTourView.tourNameField.text, !name.isEmpty,
              let location = addTourView.locationField.text, !location.isEmpty,
              let details = addTourView.remarksField.text, !details.isEmpty,
              let startDateString = addTourView.startDateField.text, !startDateString.isEmpty,
              let endDateString = addTourView.endDateField.text, !endDateString.isEmpty,
              let startDate = parseDate(from: startDateString),
              let endDate = parseDate(from: endDateString) else {
            showAlert(message: "Please fill all required fields.")
            return
        }

        guard let userUID = Auth.auth().currentUser?.uid else {
            print("User not authenticated, Firestore write blocked.")
            showAlert(message: "Authentication error. Please log in again.")
            return
        }

        let tourId = UUID().uuidString
        let tourData: [String: Any] = [
            "id": tourId,
            "name": name,
            "startDate": Timestamp(date: startDate),
            "endDate": Timestamp(date: endDate),
            "location": location,
            "details": details,
            "userUID": userUID
        ]

        print("Writing to Firestore with Data:", tourData)

        db.collection("tours").document(tourId).setData(tourData, merge: true) { [weak self] error in
            if let error = error {
                print("Firestore Write Error:", error.localizedDescription)
                self?.showAlert(message: "Error saving tour: \(error.localizedDescription)")
            } else {
                print("Tour saved successfully!")
                let newTour = Tour(id: tourId, name: name, startDate: startDate, endDate: endDate, location: location, details: details, userUID: userUID)
                self?.delegate?.didAddTour(newTour)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func populateSelectedDate() {
        guard let selectedDate = selectedDate else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        addTourView.startDateField.text = formatter.string(from: selectedDate)
    }
    
    private func parseDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        let date = formatter.date(from: dateString)
        if date == nil {
            print("Invalid date format: \(dateString)")
        }
        return date
    }
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
}

extension AddTourController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarManager.getDaysInMonth(for: calendarManager.selectedDate).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
        
        let days = calendarManager.getDaysInMonth(for: calendarManager.selectedDate)
        let date = days[indexPath.item]
        
        let isSelected = date == calendarManager.selectedDate
        let isToday = date != nil && calendarManager.isToday(date!)
        let isTourDate = date != nil && calendarManager.isTourDate(date!, for: tours)
        
        cell.configure(with: date, calendar: Calendar.current, isToday: isToday, isTourDate: isTourDate, isSelected: isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let days = calendarManager.getDaysInMonth(for: calendarManager.selectedDate)
        guard let selectedDate = days[indexPath.item] else { return }

        calendarManager.selectedDate = selectedDate

        collectionView.reloadData()
    }
}
