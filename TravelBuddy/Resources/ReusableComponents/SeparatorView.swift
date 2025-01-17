//
//  SeparatorView.swift
//  TravelBuddy
//
//  Created by MacBook on 17.01.25.
//

import UIKit

final class SeparatorView: UIView {
    
    private let leftLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .deepBlue.withAlphaComponent(0.5)
        return view
    }()
    
    private let rightLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .deepBlue.withAlphaComponent(0.5)
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "or"
        label.font = .robotoLight(size: 15)
        label.textColor = .deepBlue.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(leftLine)
        addSubview(label)
        addSubview(rightLine)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            leftLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftLine.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -8),
            leftLine.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            rightLine.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            rightLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightLine.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
