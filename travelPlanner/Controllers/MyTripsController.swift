//
//  MyTripsController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 12/1/25.
//

import UIKit
import FirebaseFirestore

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MyTripsController: UIViewController {
    
    private let myTripsView = MyTripsView()
    private let db = Firestore.firestore()
    private let calendarManager = CalendarManager()
    
    private var selectedDate: Date = Date()
    private var tours: [Tour] = []
    private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    private var selectedDay: Date?
    
    override func loadView() {
        view = myTripsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureYearAndMonthScrolls()
        configureCalendarView()
        fetchTours()
        configureToursCollectionView()
        
        selectedYear = Calendar.current.component(.year, from: Date())
        selectedMonth = Calendar.current.component(.month, from: Date())
        
        updateCalendar(for: selectedYear, month: selectedMonth)
        
        myTripsView.addTourButton.addTarget(self, action: #selector(addTourButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Configure Views
    private func configureYearAndMonthScrolls() {
        myTripsView.yearScrollView.register(YearCell.self, forCellWithReuseIdentifier: YearCell.identifier)
        myTripsView.yearScrollView.dataSource = self
        myTripsView.yearScrollView.delegate = self
        
        myTripsView.monthScrollView.register(MonthCell.self, forCellWithReuseIdentifier: MonthCell.identifier)
        myTripsView.monthScrollView.dataSource = self
        myTripsView.monthScrollView.delegate = self
    }
    
    private func configureCalendarView() {
        myTripsView.calendarView.updateCalendar(for: selectedDate, tours: tours)
    }
    
    private func configureToursCollectionView() {
        myTripsView.toursCollectionView.register(TourCell.self, forCellWithReuseIdentifier: TourCell.identifier)
        myTripsView.toursCollectionView.dataSource = self
        myTripsView.toursCollectionView.delegate = self
    }
    
    // MARK: - Fetch Tours
    private func fetchTours() {
        print("Fetching tours...")
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        db.collection("tours")
            .whereField("userUID", isEqualTo: userUID) 
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching tours: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No documents found.")
                    return
                }

                self.tours = documents.compactMap { doc -> Tour? in
                    let data = doc.data()
                    guard let name = data["name"] as? String,
                          let startDateTimestamp = data["startDate"] as? Timestamp,
                          let endDateTimestamp = data["endDate"] as? Timestamp,
                          let location = data["location"] as? String,
                          let details = data["details"] as? String else {
                        return nil
                    }

                    let startDate = startDateTimestamp.dateValue()
                    let endDate = endDateTimestamp.dateValue()

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
                    self.myTripsView.toursCollectionView.reloadData()
                    self.myTripsView.calendarView.updateCalendar(for: self.selectedDate, tours: self.tours)
                }
            }
    }
    
    // MARK: - Update Calendar
    private func updateCalendar(for year: Int, month: Int) {
        let dateComponents = DateComponents(year: year, month: month)
        if let newDate = Calendar.current.date(from: dateComponents) {
            selectedDate = newDate
            myTripsView.calendarView.updateCalendar(for: selectedDate, tours: tours)
        }
    }
    
    private func updateSelectedMonthAndYear(year: Int, month: Int) {
        let dateComponents = DateComponents(year: year, month: month)
        if let newDate = Calendar.current.date(from: dateComponents) {
            selectedDate = newDate
            myTripsView.calendarView.updateCalendar(for: newDate, tours: tours)
        }
    }
    
    @objc private func addTourButtonTapped() {
        let addTourController = AddTourController()
        addTourController.selectedDate = selectedDay
        addTourController.delegate = self
        navigationController?.pushViewController(addTourController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate for Year/Month Scrolls
extension MyTripsController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == myTripsView.yearScrollView {
            return 10
        } else if collectionView == myTripsView.monthScrollView {
            return 12
        } else if collectionView == myTripsView.toursCollectionView {
            return tours.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == myTripsView.yearScrollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YearCell.identifier, for: indexPath) as! YearCell
            let year = Calendar.current.component(.year, from: Date()) + indexPath.item
            let isSelected = year == selectedYear
            cell.configure(year: year, isSelected: isSelected)
            return cell
        } else if collectionView == myTripsView.monthScrollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthCell.identifier, for: indexPath) as! MonthCell
            let monthName = DateFormatter().monthSymbols[indexPath.item]
            let isSelected = (indexPath.item + 1) == selectedMonth
            cell.configure(month: monthName, isSelected: isSelected)
            return cell
        } else if collectionView == myTripsView.toursCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TourCell.identifier, for: indexPath) as! TourCell
            let tour = tours[indexPath.item]
            cell.configure(with: tour)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == myTripsView.yearScrollView {
            selectedYear = Calendar.current.component(.year, from: Date()) + indexPath.item
        } else if collectionView == myTripsView.monthScrollView {
            selectedMonth = indexPath.item + 1
            updateCalendar(for: selectedYear, month: selectedMonth)
            myTripsView.yearScrollView.reloadData()
            myTripsView.monthScrollView.reloadData()
        } else if collectionView == myTripsView.toursCollectionView {
            let selectedTour = tours[indexPath.item]
            let detailsController = TourDetailsController()
            detailsController.tour = selectedTour
            detailsController.delegate = self
            navigationController?.pushViewController(detailsController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == myTripsView.yearScrollView || collectionView == myTripsView.monthScrollView {
            return CGSize(width: 70, height: 35)
        } else if collectionView == myTripsView.toursCollectionView {
            return CGSize(width: UIScreen.main.bounds.width - 32, height: 100)
        }
        return CGSize.zero
    }
}

extension MyTripsController: AddTourDelegate {
    func didAddTour(_ tour: Tour) {
        tours.append(tour)

        myTripsView.toursCollectionView.reloadData()
        myTripsView.calendarView.updateCalendar(for: selectedDate, tours: tours)
    }
}

extension MyTripsController: EditTourDelegate {
    func tourDidUpdate(_ updatedTour: Tour) {
        if let index = tours.firstIndex(where: { $0.id == updatedTour.id }) {
            tours[index] = updatedTour
        }

        myTripsView.toursCollectionView.reloadData()
        myTripsView.calendarView.updateCalendar(for: selectedDate, tours: tours)
    }

    func tourDidDelete(_ deletedTourID: String) {
        tours.removeAll { $0.id == deletedTourID }

        myTripsView.toursCollectionView.reloadData()
        myTripsView.calendarView.updateCalendar(for: selectedDate, tours: tours)
    }
}
