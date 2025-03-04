//
//  EmailSentVC.swift
//  TravelBuddy
//
//  Created by MacBook on 19.01.25.
//

import UIKit

final class EmailSentVC: UIViewController {
    
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
    
    private lazy var emailSentLabel: UILabel = {
        let label = UILabel()
        label.text = "Email Sent"
        label.font = .robotoBold(size: 30)
        label.textAlignment = .right
        label.textColor = UIColor.deepBlue
        
        return label
    }()
    
    private lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .robotoLight(size: 16)
        label.textColor = .deepBlue
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var backToSignInButton: ReusableButton = {
        return ReusableButton(
            title: "Done",
            action: { [weak self] in
                self?.handleBackToSignInButton()
            }
        )
    }()
    
    var email: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noteLabel.text = """
        Please be informed that the email regarding password reset has been sent to \(email ?? "your email address"). Kindly check your inbox and follow the instructions.
        """
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [backButton, emailSentLabel, noteLabel, backToSignInButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        setupConstraints()
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
            contentView.bottomAnchor.constraint(equalTo: backToSignInButton.bottomAnchor, constant: 24),
            
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            
            emailSentLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 25),
            emailSentLabel.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            
            noteLabel.topAnchor.constraint(equalTo: emailSentLabel.bottomAnchor, constant: 25),
            noteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            noteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            backToSignInButton.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 25),
            backToSignInButton.leadingAnchor.constraint(equalTo: noteLabel.leadingAnchor),
            backToSignInButton.trailingAnchor.constraint(equalTo: noteLabel.trailingAnchor),
        ])
    }
    
    private func handleBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func handleBackToSignInButton() {
        navigationController?.popToRootViewController(animated: true)
    }
}
