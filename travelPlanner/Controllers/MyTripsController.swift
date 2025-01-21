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

class MyTripsController: UIViewController {
    
    private let calendarManager = CalendarManager()
    private var selectedDate: Date = Date()
    private var tours: [Tour] = []
    private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    private var selectedMonth: Int = Calendar.current.component(.month, from: Date())

    private let myTripsView = MyTripsView()
    private let db = Firestore.firestore()
    
    override func loadView() {
        view = myTripsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureYearAndMonthScrolls()
        configureCalendarView()
        configureTableView()
        fetchTours()

        // Initialize the default year and month
        selectedYear = Calendar.current.component(.year, from: Date())
        selectedMonth = Calendar.current.component(.month, from: Date())

        updateCalendar(for: selectedYear, month: selectedMonth)
        
        // Add Target for Add Tour Button
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
    
    private func configureTableView() {
        myTripsView.tableView.register(TourCell.self, forCellReuseIdentifier: TourCell.identifier)
        myTripsView.tableView.dataSource = self
        myTripsView.tableView.delegate = self
    }
    
    // MARK: - Fetch Tours
    private func fetchTours() {
        db.collection("tours").getDocuments { [weak self] snapshot, error in
            guard let self = self, let documents = snapshot?.documents else {
                print("Error fetching tours: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.tours = documents.compactMap { doc in
                let data = doc.data()
                guard let name = data["name"] as? String,
                      let startDate = (data["startDate"] as? Timestamp)?.dateValue(),
                      let endDate = (data["endDate"] as? Timestamp)?.dateValue(),
                      let location = data["location"] as? String,
                      let remarks = data["remarks"] as? String else { return nil }
                
                return Tour(id: doc.documentID, name: name, startDate: startDate, endDate: endDate, location: location, details: remarks)
            }
            self.myTripsView.calendarView.updateCalendar(for: self.selectedDate, tours: self.tours)
            self.myTripsView.tableView.reloadData()
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
        //addTourController.delegate = self 
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
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == myTripsView.yearScrollView {
            selectedYear = Calendar.current.component(.year, from: Date()) + indexPath.item
        } else if collectionView == myTripsView.monthScrollView {
            selectedMonth = indexPath.item + 1
        }
        
        // Ensure both year and month are selected before updating the calendar
        updateCalendar(for: selectedYear, month: selectedMonth)
        
        // Reload scroll views to reflect selection changes
        myTripsView.yearScrollView.reloadData()
        myTripsView.monthScrollView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == myTripsView.yearScrollView || collectionView == myTripsView.monthScrollView {
            return CGSize(width: 80, height: 40)
        }
        return CGSize.zero
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MyTripsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TourCell.identifier, for: indexPath) as! TourCell
        cell.configure(with: tours[indexPath.row])
        return cell
    }
}
