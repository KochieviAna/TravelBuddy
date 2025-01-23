//
//  SignInViewModel.swift
//  TravelBuddy
//
//  Created by MacBook on 23.01.25.
//

import Foundation
import FirebaseAuth

final class SignInViewModel {
    
    var onValidationError: ((String) -> Void)?
    var onSignInSuccess: (() -> Void)?
    var onSignInError: ((String) -> Void)?
    
    func signIn(email: String?, password: String?) {
        guard let email = email, isValidEmail(email) else {
            onValidationError?("Enter a valid email address.")
            return
        }
        guard let password = password, !password.isEmpty else {
            onValidationError?("Password is required.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.onSignInError?("Sign-in failed. Please check your credentials or account status. Error: \(error.localizedDescription)")
                return
            }
            
            if authResult?.user != nil {
                self?.onSignInSuccess?()
            } else {
                self?.onSignInError?("Unexpected error occurred during sign-in.")
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
