//
//  SceneDelegate.swift
//  TravelBuddy
//
//  Created by MacBook on 15.01.25.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        let hasSeenIntroduction = UserDefaults.standard.bool(forKey: "hasSeenIntroduction")
        
        let rootVC: UIViewController
        if hasSeenIntroduction {
            rootVC = SignInVC()
        } else {
            rootVC = IntroductionVC()
        }
        
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

