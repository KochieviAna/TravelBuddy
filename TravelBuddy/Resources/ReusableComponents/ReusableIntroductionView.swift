//
//  ReusableIntroductionView.swift
//  TravelBuddy
//
//  Created by MacBook on 16.01.25.
//

import UIKit

final class ReusableIntroductionView: UIView {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.backgroundColor = .primaryWhite
        view.layer.insertSublayer(createGradientLayer(), at: 0)
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.robotoSemiBold(size: 40)
        label.textColor = .primaryWhite
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.robotoLight(size: 18)
        label.textColor = .primaryWhite
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.primaryWhite.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = .primaryWhite
        pageControl.backgroundColor = .clear
        
        return pageControl
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.primaryWhite, for: .normal)
        button.titleLabel?.font = UIFont.robotoRegular(size: 25)
        button.backgroundColor = .deepBlue
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    init(
        backgroundImage: UIImage?,
        title: String,
        description: String,
        buttonTitle: String,
        showPageControl: Bool = false
    ) {
        super.init(frame: .zero)
        
        backgroundImageView.image = backgroundImage
        titleLabel.text = title
        descriptionLabel.text = description
        actionButton.setTitle(buttonTitle, for: .normal)
        pageControl.isHidden = !showPageControl
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(backgroundImageView)
        addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(pageControl)
        containerView.addSubview(actionButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            containerView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -30),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(lessThanOrEqualTo: containerView.topAnchor, constant: 49),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(lessThanOrEqualTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            pageControl.topAnchor.constraint(lessThanOrEqualTo: descriptionLabel.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            actionButton.topAnchor.constraint(lessThanOrEqualTo: pageControl.bottomAnchor, constant: 16),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -50),
            actionButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor(hex: "6B8E23", alpha: 0.5).cgColor, UIColor(hex: "B0C4DE", alpha: 1.0).cgColor]
        layer.locations = [0.0, 1.0]
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        return layer
    }()

    private func createGradientLayer() -> CAGradientLayer {
        return gradientLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
    }
}
