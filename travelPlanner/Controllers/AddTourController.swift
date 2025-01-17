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
        addTourView.saveButton.addTarget(self, action: #selector(saveTour), for: .touchUpInside)
    }
    
    @objc private func saveTour() {
        guard let tourName = addTourView.tourNameField.text,
              let location = addTourView.locationField.text,
              let remarks = addTourView.remarksField.text else { return }
        
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: 2, to: startDate)!
        
        let tourData: [String: Any] = [
            "name": tourName,
            "startDate": startDate,
            "endDate": endDate,
            "location": location,
            "remarks": remarks
        ]
        
        // Save tour to Firestore
        db.collection("tours").addDocument(data: tourData) { error in
            if let error = error {
                print("Error saving tour: \(error.localizedDescription)")
            } else {
                print("Tour saved successfully!")
                self.navigationController?.popViewController(animated: true)
            }
        }
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
        
        // Configure the cell
        if let date = date {
            let isToday = calendarManager.isToday(date)
            cell.configure(with: date, calendar: Calendar.current, isToday: isToday, isTourDate: false)
        } else {
            // Empty placeholder cells
            cell.configure(with: nil, calendar: Calendar.current, isToday: false, isTourDate: false)
        }
        
        return cell
    }
}
