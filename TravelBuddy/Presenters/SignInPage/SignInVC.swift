//
//  SignInVC.swift
//  TravelBuddy
//
//  Created by MacBook on 16.01.25.
//

import UIKit

final class SignInVC: UIViewController {
    
    private lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.font = .robotoBold(size: 30)
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
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .robotoRegular(size: 25)
        button.backgroundColor = UIColor.deepBlue
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.handleEmailSignIn()
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var separatorStackView: UIStackView = {
        let leftLine = UIView()
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.backgroundColor = .deepBlue.withAlphaComponent(0.5)
        
        NSLayoutConstraint.activate([
            leftLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        let label = UILabel()
        label.text = "or"
        label.font = .robotoLight(size: 15)
        label.textColor = .deepBlue.withAlphaComponent(0.5)
        label.textAlignment = .center
        
        let rightLine = UIView()
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        rightLine.backgroundColor = .deepBlue.withAlphaComponent(0.5)
        
        NSLayoutConstraint.activate([
            rightLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [leftLine, label, rightLine])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        leftLine.widthAnchor.constraint(equalTo: rightLine.widthAnchor).isActive = true
        leftLine.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        return stackView
    }()
    
    private lazy var googleSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Sign in with Google", for: .normal)
        button.setTitleColor(.deepBlue.withAlphaComponent(0.5), for: .normal)
        button.titleLabel?.font = .robotoMedium(size: 20)
        button.backgroundColor = .primaryWhite
        button.layer.cornerRadius = 20
        button.clipsToBounds = false

        if let googleIcon = UIImage(named: "google")?.withRenderingMode(.alwaysOriginal) {
            button.setImage(googleIcon, for: .normal)
        } else {
            print("Google icon not found in assets")
        }
        
        button.imageView?.contentMode = .scaleAspectFit

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 3

        button.addAction(UIAction(handler: { [weak self] _ in
            self?.handleGoogleSignIn()
        }), for: .touchUpInside)

        return button
    }()
    
    private lazy var appleSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Sign in with Apple", for: .normal)
        button.setTitleColor(.primaryWhite, for: .normal)
        button.titleLabel?.font = .robotoMedium(size: 20)
        button.backgroundColor = .black
        button.layer.cornerRadius = 20
        button.clipsToBounds = false
        
        let appleIcon = UIImage(systemName: "applelogo")
        button.setImage(appleIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .primaryWhite
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 3
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.handleAppleSignIn()
        }), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        [signInLabel, joinStackView, emailInputView, passwordInputView, forgotPasswordButton, signInButton, separatorStackView, googleSignInButton, appleSignInButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setupConstraints()
        
        enableTapToDismissKeyboard()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            signInLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            signInLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            joinStackView.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 10),
            joinStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            emailInputView.topAnchor.constraint(equalTo: joinStackView.bottomAnchor, constant: 40),
            emailInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            passwordInputView.topAnchor.constraint(equalTo: emailInputView.bottomAnchor, constant: 25),
            passwordInputView.leadingAnchor.constraint(equalTo: emailInputView.leadingAnchor),
            passwordInputView.trailingAnchor.constraint(equalTo: emailInputView.trailingAnchor),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordInputView.bottomAnchor, constant: 10),
            forgotPasswordButton.leadingAnchor.constraint(equalTo: passwordInputView.leadingAnchor),
            
            signInButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 25),
            signInButton.leadingAnchor.constraint(equalTo: passwordInputView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: passwordInputView.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 46),
            
            separatorStackView.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 30),
            separatorStackView.leadingAnchor.constraint(equalTo: signInButton.leadingAnchor),
            separatorStackView.trailingAnchor.constraint(equalTo: signInButton.trailingAnchor),
            
            googleSignInButton.topAnchor.constraint(equalTo: separatorStackView.bottomAnchor, constant: 30),
            googleSignInButton.leadingAnchor.constraint(equalTo: separatorStackView.leadingAnchor),
            googleSignInButton.trailingAnchor.constraint(equalTo: separatorStackView.trailingAnchor),
            googleSignInButton.heightAnchor.constraint(equalToConstant: 48),
            
            appleSignInButton.topAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: 15),
            appleSignInButton.leadingAnchor.constraint(equalTo: googleSignInButton.leadingAnchor),
            appleSignInButton.trailingAnchor.constraint(equalTo: googleSignInButton.trailingAnchor),
            appleSignInButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func handleJoinTravelBuddy() {
        print("Join Travel Buddy tapped")
    }
    
    private func handleForgotPassword() {
        print("Forgot Password tapped")
    }
    
    private func handleEmailSignIn() {
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
