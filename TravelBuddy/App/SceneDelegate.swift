//
//  SceneDelegate.swift
//  TravelBuddy
//
//  Created by MacBook on 15.01.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        let vc = IntroductionVC()
        
        window?.rootViewController = vc
        
        window?.makeKeyAndVisible()
    }
}

