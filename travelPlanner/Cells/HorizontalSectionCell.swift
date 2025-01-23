//
//  HorizontalSectionCell.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 15/1/25.
//

import UIKit
import SnapKit

class HorizontalSectionCell: UICollectionViewCell {
    static let reuseId = "horizontal_section_cell"

    var horizontalCollectionView: UICollectionView!
    var destinations: [Destination] = [] {
        didSet {
            horizontalCollectionView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHorizontalCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHorizontalCollectionView() {
        // Horizontal layout for the child collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 200, height: 250)

        // Horizontal collection view
        horizontalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        horizontalCollectionView.showsHorizontalScrollIndicator = false
        horizontalCollectionView.backgroundColor = .clear
        horizontalCollectionView.register(DestinationCell.self, forCellWithReuseIdentifier: DestinationCell.reuseId)
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.delegate = self

        contentView.addSubview(horizontalCollectionView)
        horizontalCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension HorizontalSectionCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return destinations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DestinationCell.reuseId, for: indexPath) as! DestinationCell
        let destination = destinations[indexPath.item]
        cell.configure(with: destination)
        return cell
    }
}
