//
//  ReusableLabelAndTextFieldView.swift
//  TravelBuddy
//
//  Created by MacBook on 15.01.25.
//

import UIKit

final class ReusableLabelAndTextFieldView: UIView {
    
    private lazy var labelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .deepBlue
        
        return label
    }()
        
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.robotoRegular(size: 15)
        textField.textColor = .deepBlue
        textField.backgroundColor = .clear
        textField.textAlignment = .left
        
        return textField
    }()
    
    private lazy var visibilityToggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .deepBlue
        button.isHidden = true
        button.addAction(UIAction(handler: { [weak self] action in
            self?.togglePasswordVisibility()
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.layer.cornerRadius = 8
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.deepBlue.cgColor
        stackView.clipsToBounds = true
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        return stackView
    }()
    
    private var isSecured: Bool = false
    
    var text: String {
        get {
            textField.text ?? ""
        }
        set {
            textField.text = newValue
        }
    }
    
    public var inputTextField: UITextField {
        return textField
    }
    
    init(
        label: String,
        placeholderText: String,
        font: UIFont = UIFont.robotoRegular(size: 15),
        isSecured: Bool = false,
        hasPasswordVisibility: Bool = false,
        showLockImage: Bool = false
    ) {
        super.init(frame: .zero)
        
        self.isSecured = isSecured
        
        setupUI()
        
        labelView.text = label
        labelView.font = font
        textField.placeholder = placeholderText
        textField.isSecureTextEntry = isSecured
        visibilityToggleButton.isHidden = !hasPasswordVisibility
        
        if hasPasswordVisibility {
            setupPasswordVisibilityToggle()
        }
        
        updateStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        
        addSubview(labelView)
        addSubview(stackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: topAnchor),
            labelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            stackView.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 52),
            
            visibilityToggleButton.heightAnchor.constraint(equalToConstant: 24),
            visibilityToggleButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupPasswordVisibilityToggle() {
        textField.rightView = visibilityToggleButton
        textField.rightViewMode = .always
    }
    
    private func togglePasswordVisibility() {
        isSecured.toggle()
        textField.isSecureTextEntry = isSecured
        
        let imageName = isSecured ? "eye.slash" : "eye"
        
        visibilityToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func updateStackView() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        stackView.addArrangedSubview(textField)
        
        stackView.addArrangedSubview(visibilityToggleButton)
    }
}
