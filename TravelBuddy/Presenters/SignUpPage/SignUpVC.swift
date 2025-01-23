//
//  SignUpVC.swift
//  TravelBuddy
//
//  Created by MacBook on 17.01.25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class SignUpVC: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: ReusableBackButton = {
        return ReusableBackButton { [weak self] in
            self?.handleBackButton()
        }
    }()
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.font = .robotoBold(size: 30)
        label.textAlignment = .right
        label.textColor = UIColor.deepBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fullNameInputView: ReusableLabelAndTextFieldView = {
        return ReusableLabelAndTextFieldView(
            label: "Full Name",
            placeholderText: "Your full name",
            font: .robotoRegular(size: 15),
            isSecured: false,
            hasPasswordVisibility: false
        )
    }()
    
    private lazy var emailInputView: ReusableLabelAndTextFieldView = {
        return ReusableLabelAndTextFieldView(
            label: "Email",
            placeholderText: "Your email address",
            font: .robotoRegular(size: 15),
            isSecured: false,
            hasPasswordVisibility: false
        )
    }()
    
    private lazy var passwordInputView: ReusableLabelAndTextFieldView = {
        return ReusableLabelAndTextFieldView(
            label: "Password",
            placeholderText: "Your password",
            font: .robotoRegular(size: 15),
            isSecured: true,
            hasPasswordVisibility: true
        )
    }()
    
    private lazy var confirmPasswordInputView: ReusableLabelAndTextFieldView = {
        return ReusableLabelAndTextFieldView(
            label: "Confirm Password",
            placeholderText: "Confirm your password",
            font: .robotoRegular(size: 15),
            isSecured: true,
            hasPasswordVisibility: true
        )
    }()
    
    private lazy var signUpButton: ReusableButton = {
        return ReusableButton(
            title: "Sign Up",
            action: { [weak self] in
                self?.handleSignUp()
            }
        )
    }()
    
    private let dataBase = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [backButton, signUpLabel, fullNameInputView, emailInputView, passwordInputView, confirmPasswordInputView, signUpButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        setupConstraints()
        enableTapToDismissKeyboard()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 40),
            
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            signUpLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40),
            signUpLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            fullNameInputView.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 40),
            fullNameInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            fullNameInputView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            emailInputView.topAnchor.constraint(equalTo: fullNameInputView.bottomAnchor, constant: 20),
            emailInputView.leadingAnchor.constraint(equalTo: fullNameInputView.leadingAnchor),
            emailInputView.trailingAnchor.constraint(equalTo: fullNameInputView.trailingAnchor),
            
            passwordInputView.topAnchor.constraint(equalTo: emailInputView.bottomAnchor, constant: 20),
            passwordInputView.leadingAnchor.constraint(equalTo: emailInputView.leadingAnchor),
            passwordInputView.trailingAnchor.constraint(equalTo: emailInputView.trailingAnchor),
            
            confirmPasswordInputView.topAnchor.constraint(equalTo: passwordInputView.bottomAnchor, constant: 20),
            confirmPasswordInputView.leadingAnchor.constraint(equalTo: passwordInputView.leadingAnchor),
            confirmPasswordInputView.trailingAnchor.constraint(equalTo: passwordInputView.trailingAnchor),
            
            signUpButton.topAnchor.constraint(equalTo: confirmPasswordInputView.bottomAnchor, constant: 40),
            signUpButton.leadingAnchor.constraint(equalTo: confirmPasswordInputView.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: confirmPasswordInputView.trailingAnchor),
        ])
    }
    
    private func handleBackButton() {
        print("Back button tapped")
        navigationController?.popViewController(animated: true)
    }
    
    private func handleSignUp() {
        // Retrieve input values
        guard let fullName = fullNameInputView.text, !fullName.isEmpty else {
            showAlert(message: "Please enter your full name.")
            return
        }
        guard let email = emailInputView.text, !email.isEmpty else {
            showAlert(message: "Please enter your email.")
            return
        }
        guard let password = passwordInputView.text, !password.isEmpty else {
            showAlert(message: "Please enter a password.")
            return
        }
        guard let confirmPassword = confirmPasswordInputView.text, !confirmPassword.isEmpty else {
            showAlert(message: "Please confirm your password.")
            return
        }
        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.showAlert(message: "Sign-Up Error: \(error.localizedDescription)")
                return
            }
            
            guard let self = self, let user = authResult?.user else { return }
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = fullName
            changeRequest.commitChanges { error in
                if let error = error {
                    self.showAlert(message: "Error updating profile: \(error.localizedDescription)")
                    return
                }
                
                self.saveUserToFirestore(userId: user.uid, fullName: fullName, email: email)
            }
        }
    }
    
    private func saveUserToFirestore(userId: String, fullName: String, email: String) {
        let userData: [String: Any] = [
            "fullName": fullName,
            "email": email,
            "createdAt": Timestamp(date: Date())
        ]
        
        dataBase.collection("users").document(userId).setData(userData) { [weak self] error in
            if let error = error {
                self?.showAlert(message: "Error saving user data: \(error.localizedDescription)")
                return
            }
            
            self?.showAlert(message: "Sign-Up Successful! Welcome, \(fullName)") {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "TravelBuddy", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
