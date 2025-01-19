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
        label.font = .robotoBold(size: UIScreen.main.bounds.height < 700 ? 24 : 30)
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
            
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: verticalSpacing * 2),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            newPasswordInputView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: verticalSpacing * 2),
            newPasswordInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            newPasswordInputView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            confirmPasswordInputView.topAnchor.constraint(equalTo: newPasswordInputView.bottomAnchor, constant: verticalSpacing),
            confirmPasswordInputView.leadingAnchor.constraint(equalTo: newPasswordInputView.leadingAnchor),
            confirmPasswordInputView.trailingAnchor.constraint(equalTo: newPasswordInputView.trailingAnchor),
            
            doneButton.topAnchor.constraint(equalTo: confirmPasswordInputView.bottomAnchor, constant: verticalSpacing * 2),
            doneButton.leadingAnchor.constraint(equalTo: confirmPasswordInputView.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: confirmPasswordInputView.trailingAnchor),
            doneButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -verticalSpacing * 2)
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
