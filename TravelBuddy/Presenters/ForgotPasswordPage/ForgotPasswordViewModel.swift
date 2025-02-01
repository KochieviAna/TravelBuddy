//
//  ForgotPasswordViewModel.swift
//  TravelBuddy
//
//  Created by MacBook on 23.01.25.
//

import Foundation
import FirebaseAuth

final class ForgotPasswordViewModel {
    
    var onValidationError: ((String) -> Void)?
    var onPasswordResetSuccess: (() -> Void)?
    var onPasswordResetError: ((String) -> Void)?
    
    func sendPasswordReset(email: String?) {
        guard let email = email, isValidEmail(email) else {
            onValidationError?("Please enter a valid email address.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.onPasswordResetError?("Error: \(error.localizedDescription)")
                return
            }
            self?.onPasswordResetSuccess?()
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
