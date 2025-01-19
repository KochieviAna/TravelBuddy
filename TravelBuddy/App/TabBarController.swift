//
//  TabBarController.swift
//  TravelBuddy
//
//  Created by MacBook on 19.01.25.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .deepBlue
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.stackedLayoutAppearance.normal.iconColor = .stoneGrey
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.stoneGrey
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = .deepBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.deepBlue
        ]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        let journeysVC = createNavigationController(
            rootVC: JourneysVC(),
            title: "Journeys",
            imageName: "suitcase"
        )
        
        let statisticsVC = createNavigationController(
            rootVC: StatisticsVC(),
            title: "Statistics",
            imageName: "chart.bar"
        )
        
        let profileVC = createNavigationController(
            rootVC: ProfileVC(),
            title: "Profile",
            imageName: "person"
        )
        
        viewControllers = [journeysVC, statisticsVC, profileVC]
    }
    
    private func createNavigationController(rootVC: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
        rootVC.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: imageName),
            selectedImage: UIImage(systemName: imageName + ".fill")
        )
        
        return navigationController
    }
}
