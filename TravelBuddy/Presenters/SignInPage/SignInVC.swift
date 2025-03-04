//
//  SignInVC.swift
//  TravelBuddy
//
//  Created by MacBook on 16.01.25.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FirebaseFirestore
import AuthenticationServices

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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .deepBlue
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
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
        button.setTitleColor(.stoneGrey, for: .normal)
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
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(.stoneGrey, for: .normal)
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
    
    private lazy var googleSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" Sign in with Google", for: .normal)
        button.setTitleColor(.deepBlue.withAlphaComponent(0.5), for: .normal)
        button.titleLabel?.font = .robotoMedium(size: 20)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.clipsToBounds = false
        
        if let googleIcon = UIImage(named: "google")?.withRenderingMode(.alwaysOriginal) {
            button.setImage(googleIcon, for: .normal)
        } else {
            print("Google icon not found in assets")
        }
        
        button.imageView?.contentMode = .scaleAspectFit
        
        button.layer.shadowColor = UIColor.primaryBlack.cgColor
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" Sign in with Apple", for: .normal)
        button.setTitleColor(.primaryWhite, for: .normal)
        button.titleLabel?.font = .robotoMedium(size: 20)
        button.backgroundColor = .primaryBlack
        button.layer.cornerRadius = 20
        button.clipsToBounds = false
        
        let appleIcon = UIImage(systemName: "applelogo")
        button.setImage(appleIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .primaryWhite
        
        button.layer.shadowColor = UIColor.primaryBlack.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 3
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.handleAppleSignIn()
        }), for: .touchUpInside)
        
        return button
    }()
    
    private let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(activityIndicator)
        
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
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: appleSignInButton.bottomAnchor, constant: 24),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            signInLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 80),
            signInLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            joinStackView.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 1),
            joinStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            emailInputView.topAnchor.constraint(equalTo: joinStackView.bottomAnchor, constant: 25),
            emailInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailInputView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            passwordInputView.topAnchor.constraint(equalTo: emailInputView.bottomAnchor, constant: 18),
            passwordInputView.leadingAnchor.constraint(equalTo: emailInputView.leadingAnchor),
            passwordInputView.trailingAnchor.constraint(equalTo: emailInputView.trailingAnchor),
            
            signInButton.topAnchor.constraint(equalTo: passwordInputView.bottomAnchor, constant: 18),
            signInButton.leadingAnchor.constraint(equalTo: passwordInputView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: passwordInputView.trailingAnchor),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 18),
            forgotPasswordButton.leadingAnchor.constraint(equalTo: signInButton.leadingAnchor),
            
            separatorView.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 25),
            separatorView.leadingAnchor.constraint(equalTo: signInButton.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: signInButton.trailingAnchor),
            
            googleSignInButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 25),
            googleSignInButton.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            googleSignInButton.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor),
            googleSignInButton.heightAnchor.constraint(equalToConstant: 48),
            
            appleSignInButton.topAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: 18),
            appleSignInButton.leadingAnchor.constraint(equalTo: googleSignInButton.leadingAnchor),
            appleSignInButton.trailingAnchor.constraint(equalTo: googleSignInButton.trailingAnchor),
            appleSignInButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func handleJoinTravelBuddy() {
        navigationController?.pushViewController(SignUpVC(), animated: true)
    }
    
    private func handleForgotPassword() {
        navigationController?.pushViewController(ForgotPasswordVC(), animated: true)
    }
    
    private func setupBindings() {
        viewModel.onValidationError = { [weak self] message in
            guard let self = self else { return }
            self.hideActivityIndicator()
            self.handleValidationError(message: message)
        }
        
        viewModel.onSignInError = { [weak self] message in
            guard let self = self else { return }
            self.hideActivityIndicator()
            self.showAlert(title: "Sign-In Error", message: message)
            self.setError(for: nil, message: message)
        }
        
        viewModel.onSignInSuccess = { [weak self] in
            self?.hideActivityIndicator()
            if let sceneDelegate = self?.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.switchToTabBarController()
            }
        }
    }
    
    private func handleSignIn() {
        clearErrors()
        showActivityIndicator()
        viewModel.signIn(email: emailInputView.text, password: passwordInputView.text)
    }
    
    private func handleValidationError(message: String) {
        if message.contains("email") {
            setError(for: emailInputView, message: message)
        } else if message.contains("Password") {
            setError(for: passwordInputView, message: message)
        }
    }
    
    private func setError(for inputView: ReusableLabelAndTextFieldView?, message: String) {
        inputView?.setError(message)
    }
    
    private func clearErrors() {
        emailInputView.setError(nil)
        passwordInputView.setError(nil)
    }
    
    private func handleGoogleSignIn() {
        showActivityIndicator()
        viewModel.handleGoogleSignIn(from: self) { [weak self] success, errorMessage in
            self?.hideActivityIndicator()
            if success {
                if let sceneDelegate = self?.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.switchToTabBarController()
                }
            } else if let errorMessage = errorMessage {
                self?.showAlert(title: "Google Sign-In Error", message: errorMessage)
            }
        }
    }
    
    private func handleAppleSignIn() {
        showActivityIndicator()
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        
        let nonce = viewModel.prepareAppleSignIn()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    private func showActivityIndicator() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    private func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension SignInVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            viewModel.appleSignIn(credential: appleIDCredential) { [weak self] success, errorMessage in
                self?.hideActivityIndicator()
                
                if success {
                    if let sceneDelegate = self?.view.window?.windowScene?.delegate as? SceneDelegate {
                        sceneDelegate.switchToTabBarController()
                    }
                } else if let errorMessage = errorMessage {
                    self?.showAlert(title: "Apple Sign-In Error", message: errorMessage)
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        hideActivityIndicator()
        showAlert(title: "Apple Sign-In Error", message: error.localizedDescription)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
