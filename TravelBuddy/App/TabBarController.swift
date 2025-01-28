//
//  TabBarController.swift
//  TravelBuddy
//
//  Created by MacBook on 19.01.25.
//

import UIKit
import SwiftUI
import FirebaseAuth

final class TabBarController: UITabBarController {
    var userName: String = "Unknown User"
    var userEmail: String = "Unknown Email"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        
        if let currentUser = Auth.auth().currentUser {
            userName = currentUser.displayName ?? "Unknown User"
            userEmail = currentUser.email ?? "Unknown Email"
        }
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .deepBlue
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        let journeysVC = createHostingController(
            rootView: JourneysView(),
            title: "Journeys",
            imageName: "suitcase"
        )
        
        let statisticsVC = createHostingController(
            rootView: StatisticsView(),
            title: "Statistics",
            imageName: "chart.bar"
        )
        
        let profileRootView = ProfileView(
            userName: userName,
            userEmail: userEmail,
            navigateToDetail: { [weak self] detail in
                self?.navigateToDetail(detail)
            },
            logoutAction: { [weak self] in
                self?.handleLogout()
            }
        )
        
        let profileVC = UINavigationController(rootViewController: UIHostingController(rootView: profileRootView))
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [journeysVC, statisticsVC, profileVC]
    }
    
    private func handleLogout() {
        do {
            try Auth.auth().signOut()
            
            viewControllers?.forEach { viewController in
                if let navController = viewController as? UINavigationController {
                    navController.popToRootViewController(animated: false)
                }
            }
            
            viewControllers = nil
            
            guard let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate else {
                print("Unable to access SceneDelegate.")
                return
            }
            
            let signInVC = UINavigationController(rootViewController: SignInVC())
            signInVC.navigationBar.isHidden = true
            sceneDelegate.window?.rootViewController = signInVC
            sceneDelegate.window?.makeKeyAndVisible()
            
        } catch let error {
            print("Error during logout: \(error.localizedDescription)")
        }
    }
    
    private func navigateToDetail(_ detail: String) {
        guard let selectedNavController = selectedViewController as? UINavigationController else {
            print("No navigation controller found.")
            return
        }
        
        let destinationView: UIViewController
        switch detail {
        case "Personal Details":
            destinationView = UIHostingController(rootView: PersonalDetailsView())
        case "Journey Archives":
            destinationView = UIHostingController(rootView: JourneyArchivesView())
        case "Vehicle Details":
            destinationView = UIHostingController(rootView: VehicleDetailsView().navigationBarBackButtonHidden())
        default:
            return
        }
        
        if let existingViewController = selectedNavController.viewControllers.first(where: { ($0 as? UIHostingController<PersonalDetailsView>) != nil }) {
            selectedNavController.popToViewController(existingViewController, animated: true)
        } else {
            selectedNavController.pushViewController(destinationView, animated: true)
        }
    }
    
    private func createHostingController<Content: View>(
        rootView: Content,
        title: String,
        imageName: String
    ) -> UIViewController {
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: imageName),
            selectedImage: UIImage(systemName: imageName + ".fill")
        )
        return hostingController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewControllers?.removeAll()
    }
    
    deinit {
        print("\(type(of: self)) deallocated")
    }
}
