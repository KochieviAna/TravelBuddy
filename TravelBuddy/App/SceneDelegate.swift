//
//  SceneDelegate.swift
//  TravelBuddy
//
//  Created by MacBook on 15.01.25.
//

import UIKit
import FirebaseAuth

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)

        // ✅ Check if user is already authenticated
        if Auth.auth().currentUser != nil {
            print("✅ User is already logged in: \(Auth.auth().currentUser?.email ?? "No Email")")
            window?.rootViewController = TabBarController() // Directly open main app
        } else {
            print("🔒 No user found, showing SignInVC")
            window?.rootViewController = UINavigationController(rootViewController: SignInVC())
        }
        
        window?.makeKeyAndVisible()
    }

    func switchToTabBarController() {
        let tabBarController = TabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    func switchToSignInVC() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("❌ Error signing out: \(error.localizedDescription)")
        }
        
        window?.rootViewController = UINavigationController(rootViewController: SignInVC())
        window?.makeKeyAndVisible()
    }
}
