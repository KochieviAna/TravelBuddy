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
            self?.navigationController?.popViewController(animated: true)
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
    
    private let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
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
    
    private func setupBindings() {
        viewModel.onValidationError = { [weak self] message in
            self?.handleValidationError(message: message)
        }
        
        viewModel.onSignUpError = { [weak self] message in
            self?.setError(for: nil, message: message)
        }
        
        viewModel.onSignUpSuccess = { [weak self] in
            self?.clearErrors()
            self?.showSuccessMessage()
        }
    }
    
    private func handleSignUp() {
        clearErrors()
        viewModel.signUp(
            fullName: fullNameInputView.text,
            email: emailInputView.text,
            password: passwordInputView.text,
            confirmPassword: confirmPasswordInputView.text
        )
    }
    
    private func handleValidationError(message: String) {
        if message.contains("Full name") {
            setError(for: fullNameInputView, message: message)
        } else if message.contains("email") {
            setError(for: emailInputView, message: message)
        } else if message.contains("Password") && !message.contains("match") {
            setError(for: passwordInputView, message: message)
        } else if message.contains("match") {
            setError(for: confirmPasswordInputView, message: message)
        }
    }
    
    private func setError(for inputView: ReusableLabelAndTextFieldView?, message: String) {
        inputView?.setError(message)
    }
    
    private func clearErrors() {
        fullNameInputView.setError(nil)
        emailInputView.setError(nil)
        passwordInputView.setError(nil)
        confirmPasswordInputView.setError(nil)
    }
    
    private func showSuccessMessage() {
        navigationController?.popViewController(animated: true)
    }
}
