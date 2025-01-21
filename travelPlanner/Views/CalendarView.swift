//
//  CalendarView.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 20/1/25.
//

import UIKit
import SnapKit

class CalendarView: UIView {
    
    private let calendarManager = CalendarManager()
    private var days: [Date?] = []
    var selectedDate: Date = Date()
    let calendar = Calendar.current
    var tours: [Tour] = []
    private var selectedDay: Date? // Track the selected day
    
    // Subviews
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let weekdayHeader: UIStackView = {
        let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        for weekday in weekdays {
            let label = UILabel()
            label.text = weekday
            label.textAlignment = .center
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            stackView.addArrangedSubview(label)
        }
        return stackView
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 6
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupSubviews() {
        addSubviews(monthLabel, weekdayHeader, collectionView)
    }
    
    private func setupConstraints() {
        monthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        weekdayHeader.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(weekdayHeader.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Update Calendar
    func updateCalendar(for date: Date, tours: [Tour]) {
        self.selectedDate = date
        self.tours = tours
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let daysInMonth = calendarManager.getDaysInMonth(for: selectedDate)
        return daysInMonth.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
        let daysInMonth = calendarManager.getDaysInMonth(for: selectedDate)
        let date = daysInMonth[indexPath.item]
        let isToday = date != nil && calendarManager.isToday(date!)
        let isTourDate = date != nil && calendarManager.isTourDate(date!, for: tours)
        let isSelected = date == selectedDay // Check if the date matches the selected day
        cell.configure(with: date, calendar: calendar, isToday: isToday, isTourDate: isTourDate, isSelected: isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let daysInMonth = calendarManager.getDaysInMonth(for: selectedDate)
        if let date = daysInMonth[indexPath.item] {
            selectedDay = date // Update the selected day
            collectionView.reloadData() // Refresh the collection view to apply the highlight
        }
    }
}
