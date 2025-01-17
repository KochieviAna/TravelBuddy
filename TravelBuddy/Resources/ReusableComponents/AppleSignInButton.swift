//
//  AppleSignInButton.swift
//  TravelBuddy
//
//  Created by MacBook on 17.01.25.
//

import UIKit

final class AppleSignInButton: UIView {
    
    private let buttonAction: () -> Void
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
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
            self?.buttonAction()
        }), for: .touchUpInside)
        
        return button
    }()
    
    init(action: @escaping () -> Void) {
        self.buttonAction = action
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(button)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
