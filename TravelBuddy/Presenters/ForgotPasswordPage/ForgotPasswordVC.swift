//
//  ForgotPasswordVC.swift
//  TravelBuddy
//
//  Created by MacBook on 19.01.25.
//

import UIKit

final class ForgotPasswordVC: UIViewController {
    
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
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .deepBlue
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.handleBackButton()
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password"
        label.font = .robotoBold(size: UIScreen.main.bounds.height < 700 ? 24 : 30)
        label.textAlignment = .right
        label.textColor = UIColor.deepBlue
        
        return label
    }()
    
    private lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.text = "In order to re-new the password, please insert your email below."
        label.font = .robotoLight(size: 16)
        label.textColor = .deepBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
    
    private lazy var nextButton: ReusableButton = {
        return ReusableButton(
            title: "Next",
            action: { [weak self] in
                self?.handleNextButton()
            }
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [backButton, forgotPasswordLabel, noteLabel, emailInputView, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let verticalSpacing: CGFloat = UIScreen.main.bounds.height < 700 ? 16 : 24
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalSpacing),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            
            forgotPasswordLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: verticalSpacing),
            forgotPasswordLabel.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            
            noteLabel.topAnchor.constraint(equalTo: forgotPasswordLabel.bottomAnchor, constant: verticalSpacing),
            noteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            emailInputView.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: verticalSpacing),
            emailInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailInputView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            nextButton.topAnchor.constraint(equalTo: emailInputView.bottomAnchor, constant: verticalSpacing * 2),
            nextButton.leadingAnchor.constraint(equalTo: emailInputView.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: emailInputView.trailingAnchor),
            nextButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -verticalSpacing * 2)
        ])
    }
    
    private func handleBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func handleNextButton() {
        let email = emailInputView.text
        print("Send password reset to email: \(email)")
        
        navigationController?.pushViewController(EmailSentVC(), animated: true)
    }
}
