//
//  TabBarController.swift
//  TravelBuddy
//
//  Created by MacBook on 19.01.25.
//

import UIKit
import Combine

final class TabBarController: UITabBarController {
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        observeUserState()
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
        
        let profileVC = createProfileViewController()
        
        viewControllers = [journeysVC, statisticsVC, profileVC]
    }
    
    private func createProfileViewController() -> UINavigationController {
        let rootVC: UIViewController
        
        if UserManager.shared.isGuest {
            rootVC = GuestSignInVC()
        } else {
            rootVC = ProfileVC()
        }
        
        return createNavigationController(
            rootVC: rootVC,
            title: "Profile",
            imageName: "person"
        )
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
    
    func updateProfileTabToAuthenticated() {
        let profileVC = ProfileVC()
        let profileNavController = createNavigationController(
            rootVC: profileVC,
            title: "Profile",
            imageName: "person"
        )
        
        if var viewControllers = self.viewControllers, viewControllers.count > 2 {
            viewControllers[2] = profileNavController
            self.viewControllers = viewControllers
        }
    }
    
    private func observeUserState() {
        UserManager.shared.$isGuest.sink { [weak self] isGuest in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.viewControllers?[2] = self.createProfileViewController()
            }
        }.store(in: &cancellables)
    }
}
