//
//  HomeView.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 14/1/25.
//

import UIKit
import SnapKit

class HomeView: UIView {

    private let label = TravelPlannerTitleLabel(fontSize: 22, weight: .medium)
    
    let searchBarContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Where to go?"
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {

        addSubview(label)
        addSubview(searchBarContainer)
        searchBarContainer.addSubview(searchIcon)
        searchBarContainer.addSubview(searchTextField)
        
        label.textColor = .white
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        searchBarContainer.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(label.snp.bottom).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.leading.equalTo(searchBarContainer).offset(16)
            make.centerY.equalTo(searchBarContainer)
            make.width.height.equalTo(20)
        }
        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(searchIcon.snp.trailing).offset(8)
            make.centerY.equalTo(searchBarContainer)
            make.trailing.equalTo(searchBarContainer).offset(-16)
        }
    }
    
    func updateGreeting(with userName: String) {
        label.text = "Hello, \(userName)!"
    }
}
