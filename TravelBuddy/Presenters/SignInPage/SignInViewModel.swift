//
//  SignInViewModel.swift
//  TravelBuddy
//
//  Created by MacBook on 23.01.25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import FirebaseCore
import AuthenticationServices
import CryptoKit

final class SignInViewModel {
    
    var onValidationError: ((String) -> Void)?
    var onSignInSuccess: (() -> Void)?
    var onSignInError: ((String) -> Void)?
    
    var currentNonce: String?
    
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

extension SignInViewModel {
    
    func handleGoogleSignIn(from viewController: UIViewController, completion: @escaping (Bool, String?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(false, "Firebase client ID not found. Please check your Firebase configuration.")
            return
        }
        
        let configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                completion(false, "Google Sign-In failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(false, "Unable to retrieve Google user information.")
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(false, "Firebase Sign-In failed: \(error.localizedDescription)")
                    return
                }
                
                guard let uid = authResult?.user.uid else {
                    completion(false, "Unexpected error occurred.")
                    return
                }
                
                let userName = user.profile?.name ?? "Unknown User"
                let userEmail = user.profile?.email ?? "Unknown Email"
                
                let db = Firestore.firestore()
                let userData: [String: Any] = [
                    "name": userName,
                    "email": userEmail,
                    "createdAt": FieldValue.serverTimestamp()
                ]
                
                db.collection("users").document(uid).setData(userData) { error in
                    if let error = error {
                        print("Error saving user data: \(error.localizedDescription)")
                        completion(false, "Error saving user data.")
                    } else {
                        print("User data successfully saved!")
                        completion(true, nil)
                    }
                }
            }
        }
    }
}

extension SignInViewModel {
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func appleSignIn(credential: ASAuthorizationAppleIDCredential, completion: @escaping (Bool, String?) -> Void) {
        guard let identityToken = credential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8) else {
            completion(false, "Unable to retrieve identity token.")
            return
        }
        
        guard let nonce = currentNonce else {
            completion(false, "Invalid state: a nonce was not set.")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: tokenString,
            rawNonce: nonce
        )
        Auth.auth().signIn(with: firebaseCredential) { authResult, error in
            if let error = error {
                completion(false, "Firebase sign-in failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else {
                completion(false, "User not found after sign-in.")
                return
            }
            
            print("Successfully signed in with Apple: \(user.uid)")
            completion(true, nil)
        }
    }
    
    func prepareAppleSignIn() -> String {
        let nonce = randomNonceString()
        currentNonce = nonce
        return sha256(nonce)
    }
}
