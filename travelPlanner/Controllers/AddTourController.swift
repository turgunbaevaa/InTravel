//
//  AddTourController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 17/1/25.
//

import UIKit
import FirebaseFirestore

class AddTourController: UIViewController {
    
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
              let startDateString = addTourView.dateLabel.text, !startDateString.isEmpty,
              let startDate = parseDate(from: startDateString) else {
            print("Name: \(addTourView.tourNameField.text ?? "nil")")
            print("Location: \(addTourView.locationField.text ?? "nil")")
            print("Details: \(addTourView.remarksField.text ?? "nil")")
            print("Start Date: \(addTourView.dateLabel.text ?? "nil")")
            showAlert(message: "Please fill all required fields.")
            return
        }
        
        print("Parsed Data: \(name), \(location), \(details), \(startDate)")
        
        let endDate = startDate
        
        // Generate a unique ID for the tour
        let tourId = UUID().uuidString
        
        let newTour = Tour(id: tourId, name: name, startDate: startDate, endDate: endDate, location: location, details: details)
        
        db.collection("tours").document(tourId).setData(newTour.toDictionary()) { error in
            if let error = error {
                self.showAlert(message: "Error saving tour: \(error.localizedDescription)")
            } else {
                self.showAlert(message: "Tour saved successfully!")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func populateSelectedDate() {
        guard let selectedDate = selectedDate else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        addTourView.dateLabel.text = formatter.string(from: selectedDate)
    }
    
    private func parseDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.date(from: dateString)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
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
