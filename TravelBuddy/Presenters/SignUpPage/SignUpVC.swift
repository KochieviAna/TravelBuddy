//
//  SignUpVC.swift
//  TravelBuddy
//
//  Created by MacBook on 17.01.25.
//

import UIKit

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
        label.font = .robotoBold(size: UIScreen.main.bounds.height < 700 ? 24 : 30)
        label.textAlignment = .right
        label.textColor = UIColor.deepBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var fullNameInputView: ReusableLabelAndTextFieldView = {
        let view = ReusableLabelAndTextFieldView(
            label: "Full Name",
            placeholderText: "Enter your full name",
            font: .robotoRegular(size: 15),
            isSecured: false,
            hasPasswordVisibility: false
        )
        
        return view
    }()
    
    private lazy var emailInputView: ReusableLabelAndTextFieldView = {
        let view = ReusableLabelAndTextFieldView(
            label: "Email",
            placeholderText: "Enter your email",
            font: .robotoRegular(size: 15),
            isSecured: false,
            hasPasswordVisibility: false
        )
        
        return view
    }()
    
    private lazy var passwordInputView: ReusableLabelAndTextFieldView = {
        let view = ReusableLabelAndTextFieldView(
            label: "Password",
            placeholderText: "Enter your password",
            font: .robotoRegular(size: 15),
            isSecured: true,
            hasPasswordVisibility: true
        )
        
        return view
    }()
    
    private lazy var confirmPasswordInputView: ReusableLabelAndTextFieldView = {
        let view = ReusableLabelAndTextFieldView(
            label: "Confirm Password",
            placeholderText: "Confirm your password",
            font: .robotoRegular(size: 15),
            isSecured: true,
            hasPasswordVisibility: true
        )
        
        return view
    }()
    
    private lazy var signUpButton: ReusableButton = {
        return ReusableButton(
            title: "Sign Up",
            action: { [weak self] in
                self?.handleSignUp()
            }
        )
    }()
    
    private lazy var separatorView = SeparatorView()
    
    private lazy var googleSignUpButton: GoogleSignInButton = {
        return GoogleSignInButton { [weak self] in
            self?.handleGoogleSignUp()
        }
    }()
    
    private lazy var appleSignUpButton: AppleSignInButton = {
        return AppleSignInButton { [weak self] in
            self?.handleAppleSignUp()
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [backButton, signUpLabel, fullNameInputView, emailInputView, passwordInputView, confirmPasswordInputView, signUpButton, separatorView, googleSignUpButton, appleSignUpButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        setupConstraints()
        
        enableTapToDismissKeyboard()
    }
    
    private func setupConstraints() {
        let verticalSpacing: CGFloat = UIScreen.main.bounds.height < 700 ? 16 : 24
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalSpacing),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            signUpLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: verticalSpacing * 2),
            signUpLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            fullNameInputView.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: verticalSpacing * 2),
            fullNameInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            fullNameInputView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            emailInputView.topAnchor.constraint(equalTo: fullNameInputView.bottomAnchor, constant: verticalSpacing),
            emailInputView.leadingAnchor.constraint(equalTo: fullNameInputView.leadingAnchor),
            emailInputView.trailingAnchor.constraint(equalTo: fullNameInputView.trailingAnchor),
            
            passwordInputView.topAnchor.constraint(equalTo: emailInputView.bottomAnchor, constant: verticalSpacing),
            passwordInputView.leadingAnchor.constraint(equalTo: emailInputView.leadingAnchor),
            passwordInputView.trailingAnchor.constraint(equalTo: emailInputView.trailingAnchor),
            
            confirmPasswordInputView.topAnchor.constraint(equalTo: passwordInputView.bottomAnchor, constant: verticalSpacing),
            confirmPasswordInputView.leadingAnchor.constraint(equalTo: passwordInputView.leadingAnchor),
            confirmPasswordInputView.trailingAnchor.constraint(equalTo: passwordInputView.trailingAnchor),
            
            signUpButton.topAnchor.constraint(equalTo: confirmPasswordInputView.bottomAnchor, constant: verticalSpacing * 2),
            signUpButton.leadingAnchor.constraint(equalTo: confirmPasswordInputView.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: confirmPasswordInputView.trailingAnchor),
            
            separatorView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: verticalSpacing * 2),
            separatorView.leadingAnchor.constraint(equalTo: signUpButton.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: signUpButton.trailingAnchor),
            
            googleSignUpButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: verticalSpacing * 2),
            googleSignUpButton.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            googleSignUpButton.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor),
            
            appleSignUpButton.topAnchor.constraint(equalTo: googleSignUpButton.bottomAnchor, constant: verticalSpacing),
            appleSignUpButton.leadingAnchor.constraint(equalTo: googleSignUpButton.leadingAnchor),
            appleSignUpButton.trailingAnchor.constraint(equalTo: googleSignUpButton.trailingAnchor),
            appleSignUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalSpacing * 2)
        ])
    }
    
    private func handleBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func handleSignUp() {
        let fullName = fullNameInputView.text
        let email = emailInputView.text
        let password = passwordInputView.text
        let confirmPassword = confirmPasswordInputView.text
        print("Full Name: \(fullName), Email: \(email), Password: \(password), Confirm Password: \(confirmPassword)")
    }
    
    private func handleGoogleSignUp() {
        print("Google Sign-Up tapped")
    }
    
    private func handleAppleSignUp() {
        print("Apple Sign-Up tapped")
    }
}
