//
//  TabBarController.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 12/1/25.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupTabBarUI()
    }
    
    //MARK: Setup TabBar UI:
    private func setupTabBarUI() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground() // Use this for a solid color background
        appearance.backgroundColor = UIColor(hex: "#F6F6F6")
        
        // Apply the appearance to the tab bar
        tabBar.standardAppearance = appearance
        
        // For iOS 15 and later, set the scroll edge appearance as well
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = UIColor(hex: "#362E83")
        tabBar.unselectedItemTintColor = UIColor(hex: "#6C757D")
        
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    //MARK: Tab Setup
    private func setupTabs() {
        let home = self.createNav(with: "Home", and: UIImage(systemName: "house"), vc: HomeController())
        let myTrips = self.createNav(with: "My Trips", and: UIImage(systemName: "map"), vc: MyTripsController())
        let budget = self.createNav(with: "Plan your budget", and: UIImage(systemName: "eurosign.square"), vc: BudgetController())
        let account = self.createNav(with: "Account", and: UIImage(systemName: "person"), vc: AccountController())
        self.setViewControllers([home, myTrips, budget, account], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        
        nav.viewControllers.first?.navigationItem.title = title
        
        return nav
    }
}
