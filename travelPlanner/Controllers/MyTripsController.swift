//
//  MyTripsController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 12/1/25.
//

import UIKit
import FirebaseFirestore

class MyTripsController: UIViewController {
    
    private let calendarManager = CalendarManager()
    private var selectedDate: Date = Date()
    private var tours: [Tour] = [] // Fetched from Firebase

    private let myTripsView = MyTripsView()
    private let db = Firestore.firestore()
    
    override func loadView() {
        view = myTripsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureCollectionView()
        configureTableView()
        fetchTours()
    }
    
    // MARK: - Setup
    private func setupView() {
        let years = ["2025", "2026", "2027", "2028", "2029", "2030"]
        for year in years {
            let yearButton = UIButton()
            yearButton.setTitle(year, for: .normal)
            yearButton.setTitleColor(year == "2025" ? .orange : .white, for: .normal)
            yearButton.addTarget(self, action: #selector(selectYear(_:)), for: .touchUpInside)
            myTripsView.yearStackView.addArrangedSubview(yearButton)
        }

        // Setup month buttons
        let months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN"]
        for (index, month) in months.enumerated() {
            let monthButton = UIButton()
            monthButton.setTitle(month, for: .normal)
            monthButton.setTitleColor(index == 0 ? .orange : .white, for: .normal)
            monthButton.addTarget(self, action: #selector(selectMonth(_:)), for: .touchUpInside)
            myTripsView.monthStackView.addArrangedSubview(monthButton)
        }

        // Set initial month label
        myTripsView.monthLabel.text = calendarManager.getMonthName(for: selectedDate)
        myTripsView.addTourButton.addTarget(self, action: #selector(addTourTapped), for: .touchUpInside)
    }
    
    private func configureCollectionView() {
        myTripsView.collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
        myTripsView.collectionView.dataSource = self
        myTripsView.collectionView.delegate = self
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
            self.myTripsView.collectionView.reloadData()
            self.myTripsView.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    @objc private func selectMonth(_ sender: UIButton) {
        guard let monthName = sender.title(for: .normal) else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        if let newDate = formatter.date(from: "\(monthName) \(Calendar.current.component(.year, from: calendarManager.selectedDate))") {
            calendarManager.selectedDate = newDate
            myTripsView.monthLabel.text = calendarManager.getMonthName(for: newDate)
            myTripsView.collectionView.reloadData()
        }
    }

    @objc private func selectYear(_ sender: UIButton) {
        guard let year = sender.title(for: .normal), let newYear = Int(year) else { return }
        if let newDate = calendarManager.calendar.date(bySetting: .year, value: newYear, of: calendarManager.selectedDate) {
            calendarManager.selectedDate = newDate
            myTripsView.monthLabel.text = calendarManager.getMonthName(for: newDate)
            myTripsView.collectionView.reloadData()
        }
    }
    
    @objc private func addTourTapped() {
        let addTourVC = AddTourController()
        navigationController?.pushViewController(addTourVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension MyTripsController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarManager.getDaysInMonth(for: calendarManager.selectedDate).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
        let days = calendarManager.getDaysInMonth(for: calendarManager.selectedDate)

        // Safely unwrap the optional date at the given index
        if let date = days[indexPath.item] {
            let isToday = calendarManager.isToday(date)
            let isTourDate = calendarManager.isTourDate(date, for: tours)
            
            // Configure the cell with valid date
            cell.configure(with: date, calendar: Calendar.current, isToday: isToday, isTourDate: isTourDate)
        } else {
            // Configure the cell for an empty placeholder (e.g., empty date slot at the start of the month)
            cell.configure(with: nil, calendar: Calendar.current, isToday: false, isTourDate: false)
        }
        
        return cell
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
