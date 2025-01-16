//
//  HomeController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 1/1/25.
//

import UIKit
import SnapKit
import SDWebImage

class HomeController: UIViewController {
    
    //MARK: - UI Components
    
    private let homeView = HomeView()
    private var collectionView: UICollectionView!
    private var destinations: [Destination] = []
    private var sections: [Section] = []
    private var filteredSections: [Section] = [] // Filtered sections based on the search
    private var isSearching = false // Flag to track if search is active
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        fetchDestinations() // Fetch data when view loads
        
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                AlertManager.showFetchinUserError(on: self, with: error)
                return
            }
            if let user = user {
                DispatchQueue.main.async {
                    self.homeView.updateGreeting(with: user.name)
                }
            }
        }
        
        homeView.searchTextField.delegate = self
    }
    
    // Fetch data from NetworkManager
    private func fetchDestinations() {
        NetworkManager.shared.fetchDestinations { [weak self] destinations, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching destinations:", error.localizedDescription)
                return
            }
            
            if let destinations = destinations {
                // Filter destinations by type
                let places = destinations.filter { $0.type == "Place" }
                let hotels = destinations.filter { $0.type == "Hotel" }
                
                // Debugging: Check the counts of filtered results
                print("Fetched Places Count:", places.count)
                print("Fetched Hotels Count:", hotels.count)
                
                // Create sections
                self.sections = [
                    Section(title: "Places", destinations: places),
                    Section(title: "Hotels", destinations: hotels)
                ]
                
                // Debugging: Check section data
                print("Sections Created: \(self.sections.map { $0.title })")
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    //MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.init(hex: "#362E83")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right")?.withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(didTapLogout)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        view.addSubview(homeView)
        homeView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func didTapLogout() {
        AuthService.shared.signOut { [weak self] error in
            guard let self else { return }
            
            if let error = error {
                AlertManager.showLogOutErrorAlert(on: self, with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HorizontalSectionCell.self, forCellWithReuseIdentifier: HorizontalSectionCell.reuseId)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(homeView.searchTextField.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
}

extension HomeController: UITextFieldDelegate {
    // UITextFieldDelegate: Handle text changes
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)

        if updatedText.isEmpty {
            // No search term: reset to original sections
            isSearching = false
            filteredSections = sections
        } else {
            // Filter sections based on search term
            isSearching = true
            filteredSections = sections.map { section in
                let filteredDestinations = section.destinations.filter { destination in
                    destination.name.lowercased().contains(updatedText.lowercased()) ||
                    destination.description.lowercased().contains(updatedText.lowercased()) ||
                    destination.locationName.lowercased().contains(updatedText.lowercased())
                }
                return Section(title: section.title, destinations: filteredDestinations)
            }.filter { !$0.destinations.isEmpty } // Remove sections with no destinations
        }

        // Debugging: Check the filtered data
        print("Search Text: \(updatedText)")
        print("Filtered Sections Count: \(filteredSections.count)")
        filteredSections.forEach { section in
            print("Section: \(section.title), Destinations: \(section.destinations.map { $0.name })")
        }

        collectionView.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// UICollectionView DataSource & Delegate
extension HomeController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = isSearching ? filteredSections.count : sections.count
        print("Number of Sections:", count)
        return count
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let dataSource = isSearching ? filteredSections : sections
//        let count = dataSource[section].destinations.count
//        print("Number of Items in Section \(section):", count)
//        return count
//    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 // Only one cell per section, which contains the horizontal collection view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataSource = isSearching ? filteredSections : sections
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalSectionCell.reuseId, for: indexPath) as! HorizontalSectionCell
        cell.destinations = dataSource[indexPath.section].destinations
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let dataSource = isSearching ? filteredSections : sections
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseId, for: indexPath) as! HeaderView
        header.titleLabel.text = dataSource[indexPath.section].title // Correct title based on current data source
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 280)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50) // Header size
    }
}
