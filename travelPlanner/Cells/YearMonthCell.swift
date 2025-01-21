//
//  YearMonthCell.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 18/1/25.
//

import UIKit
import SnapKit

class YearMonthCell: UICollectionViewCell {
    static let identifier = "year_month_cell"
    
    private let yearsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40) // Each year button size
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let monthsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40) // Each month button size
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    private var selectedMonth: Int?
    private var onMonthSelected: ((Int, Int) -> Void)?
    
    private let years = ["2025", "2026", "2027", "2028", "2029", "2030", "2031"]
    private var selectedYear: Int?
    private var onYearSelected: ((Int) -> Void)? 

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(yearsCollectionView, monthsCollectionView)
        
        yearsCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }

        monthsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(yearsCollectionView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4) 
            make.height.equalTo(40)
        }
        
        setupYearsCollectionView()
        setupMonthsCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupYearsCollectionView() {
        yearsCollectionView.register(YearCell.self, forCellWithReuseIdentifier: YearCell.identifier)
        yearsCollectionView.dataSource = self
        yearsCollectionView.delegate = self
    }
    
    private func setupMonthsCollectionView() {
        monthsCollectionView.register(MonthCell.self, forCellWithReuseIdentifier: MonthCell.identifier)
        monthsCollectionView.dataSource = self
        monthsCollectionView.delegate = self
    }
    
    func configure(selectedYear: Int?, selectedMonth: Int?, onYearSelected: @escaping (Int) -> Void, onMonthSelected: @escaping (Int, Int) -> Void) {
        self.selectedYear = selectedYear
        self.selectedMonth = selectedMonth
        self.onYearSelected = onYearSelected
        self.onMonthSelected = onMonthSelected
        yearsCollectionView.reloadData()
        monthsCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate for Years
extension YearMonthCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == yearsCollectionView {
            return years.count
        } else {
            return months.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == yearsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YearCell.identifier, for: indexPath) as! YearCell
            let year = Int(years[indexPath.item])!
            let isSelected = year == selectedYear
            cell.configure(year: year, isSelected: isSelected)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthCell.identifier, for: indexPath) as! MonthCell
            let isSelected = indexPath.item + 1 == selectedMonth
            cell.configure(month: months[indexPath.item], isSelected: isSelected)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == yearsCollectionView {
            selectedYear = Int(years[indexPath.item])!
            collectionView.reloadData()
            onYearSelected?(selectedYear!)
        } else {
            selectedMonth = indexPath.item + 1
            collectionView.reloadData()
            if let year = selectedYear {
                onMonthSelected?(year, selectedMonth!)
            }
        }
    }
}

