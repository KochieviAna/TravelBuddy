//
//  SignUpViewModel.swift
//  TravelBuddy
//
//  Created by MacBook on 23.01.25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class SignUpViewModel {
    
    private let database = Firestore.firestore()
    
    var onValidationError: ((String) -> Void)?
    var onSignUpSuccess: (() -> Void)?
    var onSignUpError: ((String) -> Void)?
    
    func signUp(fullName: String?, email: String?, password: String?, confirmPassword: String?) {
        guard let fullName = fullName, !fullName.isEmpty else {
            onValidationError?("Full name is required.")
            return
        }
        guard let email = email, isValidEmail(email) else {
            onValidationError?("Enter a valid email address.")
            return
        }
        guard let password = password, !password.isEmpty else {
            onValidationError?("Password is required.")
            return
        }
        guard password.count >= 6 else {
            onValidationError?("Password must be at least 6 characters.")
            return
        }
        guard password == confirmPassword else {
            onValidationError?("Passwords do not match.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.onSignUpError?("Sign-Up Error: \(error.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else { return }
            self?.updateUserProfile(user: user, fullName: fullName, email: email)
        }
    }
    
    private func updateUserProfile(user: User, fullName: String, email: String) {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = fullName
        changeRequest.commitChanges { [weak self] error in
            if let error = error {
                self?.onSignUpError?("Error updating profile: \(error.localizedDescription)")
                return
            }
            self?.saveUserToFirestore(userId: user.uid, fullName: fullName, email: email)
        }
    }
    
    private func saveUserToFirestore(userId: String, fullName: String, email: String) {
        let userData: [String: Any] = [
            "fullName": fullName,
            "email": email,
            "createdAt": Timestamp(date: Date())
        ]
        
        database.collection("users").document(userId).setData(userData) { [weak self] error in
            if let error = error {
                self?.onSignUpError?("Error saving user data: \(error.localizedDescription)")
                return
            }
            self?.onSignUpSuccess?()
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
