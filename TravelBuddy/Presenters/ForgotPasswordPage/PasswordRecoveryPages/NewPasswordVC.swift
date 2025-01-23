//
//  NewPasswordVC.swift
//  TravelBuddy
//
//  Created by MacBook on 19.01.25.
//

import UIKit

final class NewPasswordVC: UIViewController {
    
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create New Password"
        label.font = .robotoBold(size: 30)
        label.textAlignment = .right
        label.textColor = UIColor.deepBlue
        
        return label
    }()
    
    private lazy var newPasswordInputView: ReusableLabelAndTextFieldView = {
        return ReusableLabelAndTextFieldView(
            label: "Enter New Password",
            placeholderText: "New password",
            font: .robotoRegular(size: 15),
            isSecured: true,
            hasPasswordVisibility: true
        )
    }()
    
    private lazy var confirmPasswordInputView: ReusableLabelAndTextFieldView = {
        return ReusableLabelAndTextFieldView(
            label: "Confirm New Password",
            placeholderText: "Confirm new password",
            font: .robotoRegular(size: 15),
            isSecured: true,
            hasPasswordVisibility: true
        )
    }()
    
    private lazy var doneButton: ReusableButton = {
        return ReusableButton(
            title: "Done",
            action: { [weak self] in
                self?.handleDoneButton()
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
        
        [titleLabel, newPasswordInputView, confirmPasswordInputView, doneButton].forEach {
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
            contentView.bottomAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 70),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            newPasswordInputView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            newPasswordInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            newPasswordInputView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            confirmPasswordInputView.topAnchor.constraint(equalTo: newPasswordInputView.bottomAnchor, constant: 18),
            confirmPasswordInputView.leadingAnchor.constraint(equalTo: newPasswordInputView.leadingAnchor),
            confirmPasswordInputView.trailingAnchor.constraint(equalTo: newPasswordInputView.trailingAnchor),
            
            doneButton.topAnchor.constraint(equalTo: confirmPasswordInputView.bottomAnchor, constant: 18),
            doneButton.leadingAnchor.constraint(equalTo: confirmPasswordInputView.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: confirmPasswordInputView.trailingAnchor),
        ])
    }
    
    private func handleDoneButton() {
        let newPassword = newPasswordInputView.text
        let confirmPassword = confirmPasswordInputView.text
        
        guard newPassword == confirmPassword else {
            print("Passwords do not match!")
            return
        }
        
        print("New password set: \(newPassword)")
        
        navigationController?.popToRootViewController(animated: true)
    }
}
