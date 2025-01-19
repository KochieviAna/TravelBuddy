//
//  SignInVC.swift
//  TravelBuddy
//
//  Created by MacBook on 16.01.25.
//

import UIKit

final class SignInVC: UIViewController {
    
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
    
    private lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.font = .robotoBold(size: UIScreen.main.bounds.height < 700 ? 24 : 30)
        label.textAlignment = .right
        label.textColor = UIColor.deepBlue
        return label
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.text = "or"
        label.font = .robotoLight(size: 15)
        label.textColor = .deepBlue
        return label
    }()
    
    private lazy var joinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Join Travel Buddy", for: .normal)
        button.setTitleColor(.skyBlue, for: .normal)
        button.titleLabel?.font = .robotoBold(size: 15)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.handleJoinTravelBuddy()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var joinStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [orLabel, joinButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var emailInputView: ReusableLabelAndTextFieldView = {
        return ReusableLabelAndTextFieldView(
            label: "Email",
            placeholderText: "Enter your email",
            font: .robotoRegular(size: 15),
            isSecured: false,
            hasPasswordVisibility: false
        )
    }()
    
    private lazy var passwordInputView: ReusableLabelAndTextFieldView = {
        return ReusableLabelAndTextFieldView(
            label: "Password",
            placeholderText: "Enter your password",
            font: .robotoRegular(size: 15),
            isSecured: true,
            hasPasswordVisibility: true
        )
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(.skyBlue, for: .normal)
        button.titleLabel?.font = .robotoRegular(size: 12)
        button.contentHorizontalAlignment = .right
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.handleForgotPassword()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var signInButton: ReusableButton = {
        return ReusableButton(
            title: "Sign In",
            action: { [weak self] in
                self?.handleSignIn()
            }
        )
    }()
    
    private lazy var separatorView = SeparatorView()
    
    private lazy var googleSignInButton: GoogleSignInButton = {
        return GoogleSignInButton { [weak self] in
            self?.handleGoogleSignIn()
        }
    }()
    
    private lazy var appleSignInButton: AppleSignInButton = {
        return AppleSignInButton { [weak self] in
            self?.handleAppleSignIn()
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
        
        [signInLabel, joinStackView, emailInputView, passwordInputView, forgotPasswordButton, signInButton, separatorView, googleSignInButton, appleSignInButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        setupConstraints()
        
        enableTapToDismissKeyboard()
    }
    
    private func setupConstraints() {
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
            
            signInLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 60),
            signInLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            joinStackView.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 10),
            joinStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            emailInputView.topAnchor.constraint(equalTo: joinStackView.bottomAnchor, constant: 20),
            emailInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailInputView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            passwordInputView.topAnchor.constraint(equalTo: emailInputView.bottomAnchor, constant: 15),
            passwordInputView.leadingAnchor.constraint(equalTo: emailInputView.leadingAnchor),
            passwordInputView.trailingAnchor.constraint(equalTo: emailInputView.trailingAnchor),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordInputView.bottomAnchor, constant: 10),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: passwordInputView.trailingAnchor),
            
            signInButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 20),
            signInButton.leadingAnchor.constraint(equalTo: passwordInputView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: passwordInputView.trailingAnchor),
            
            separatorView.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            separatorView.leadingAnchor.constraint(equalTo: signInButton.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: signInButton.trailingAnchor),
            
            googleSignInButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20),
            googleSignInButton.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            googleSignInButton.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor),
            
            appleSignInButton.topAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: 15),
            appleSignInButton.leadingAnchor.constraint(equalTo: googleSignInButton.leadingAnchor),
            appleSignInButton.trailingAnchor.constraint(equalTo: googleSignInButton.trailingAnchor),
            appleSignInButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func handleJoinTravelBuddy() {
        navigationController?.pushViewController(SignUpVC(), animated: true)
    }
    
    private func handleForgotPassword() {
        print("Forgot Password tapped")
    }
    
    private func handleSignIn() {
        let email = emailInputView.text
        let password = passwordInputView.text
        print("Email: \(email), Password: \(password)")
    }
    
    private func handleGoogleSignIn() {
        print("Google Sign-In tapped")
    }
    
    private func handleAppleSignIn() {
        print("Apple Sign-In tapped")
    }
}
