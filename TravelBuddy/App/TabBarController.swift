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
            print("✅ User logged out successfully.")
            
            guard let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate else {
                print("❌ Unable to access SceneDelegate.")
                return
            }

            sceneDelegate.switchToSignInVC()

        } catch let error {
            print("❌ Error during logout: \(error.localizedDescription)")
        }
    }

    private func navigateToDetail(_ detail: String) {
        guard let selectedNavController = selectedViewController as? UINavigationController else {
            print("No navigation controller found.")
            return
        }

        var destinationView: UIViewController?

        switch detail {
        case "Personal Details":
            destinationView = UIHostingController(rootView:
                PersonalDetailsView(
                    userName: userName,
                    userEmail: userEmail,
                    onChangePassword: { [weak self] in
                        self?.navigateToForgotPassword()
                    }
                )
                .navigationBarHidden(true) // ✅ Ensures navigation bar is hidden
            )

        case "Journey Archives":
            let journeyArchivesView = JourneyArchivesView { [weak self] archivedJourney in
                self?.navigateToArchivedJourneyDetail(archivedJourney)
            }

            // ✅ Correcting navigation bar hiding
            let hostingController = UIHostingController(rootView: journeyArchivesView)
            hostingController.navigationItem.hidesBackButton = true // Hide default back button
            hostingController.navigationController?.setNavigationBarHidden(true, animated: false)

            destinationView = hostingController

        case "Vehicle Details":
            destinationView = UIHostingController(rootView:
                VehicleDetailsView()
                    .navigationBarHidden(true) // ✅ Hide navigation bar
            )

        default:
            return
        }

        if let existingViewController = selectedNavController.viewControllers.first(where: { type(of: $0) == type(of: destinationView!) }) {
            selectedNavController.popToViewController(existingViewController, animated: true)
        } else {
            selectedNavController.pushViewController(destinationView!, animated: true)
        }
    }

    private func navigateToArchivedJourneyDetail(_ archivedJourney: ArchivedJourney) {
        guard let selectedNavController = selectedViewController as? UINavigationController else {
            print("No navigation controller found.")
            return
        }

        let archivedDetailView = UIHostingController(
            rootView: ArchivedJourneyDetailView(journey: archivedJourney)
                .navigationBarHidden(true)
        )
        
        // ✅ Ensure back button is hidden
        archivedDetailView.navigationItem.hidesBackButton = true
        archivedDetailView.navigationController?.setNavigationBarHidden(true, animated: false)

        selectedNavController.pushViewController(archivedDetailView, animated: true)
    }

    private func navigateToForgotPassword() {
        let forgotPasswordVC = ForgotPasswordVC()

        if let selectedNavController = selectedViewController as? UINavigationController {
            selectedNavController.pushViewController(forgotPasswordVC, animated: true)
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
    }

    deinit {
        print("\(type(of: self)) deallocated")
    }
}
