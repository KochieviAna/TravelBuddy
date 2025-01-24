//
//  GuestSignInVC.swift
//  TravelBuddy
//
//  Created by MacBook on 24.01.25.
//

import UIKit


final class GuestSignInVC: SignInVC {
    
    override func setupUI() {
        super.setupUI()
        
        continueAsGuestButton.isHidden = true
        guestSeparatorView.isHidden = true
    }
    
    override func handleSignIn() {
        clearErrors()
        showActivityIndicator()
        viewModel.signIn(email: emailInputView.text, password: passwordInputView.text)
    }
    
    override func handleGoogleSignIn() {
        showActivityIndicator()
        viewModel.handleGoogleSignIn(from: self) { [weak self] success, errorMessage in
            self?.hideActivityIndicator()
            if success {
                UserManager.shared.isGuest = false
                if let sceneDelegate = self?.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.switchToTabBarController()
                }
            } else if let errorMessage = errorMessage {
                self?.showAlert(title: "Google Sign-In Error", message: errorMessage)
            }
        }
    }
}
