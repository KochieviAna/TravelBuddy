//
//  IntroductionVC.swift
//  TravelBuddy
//
//  Created by MacBook on 15.01.25.
//

import UIKit

final class IntroductionVC: UIViewController {
    
    private var currentPage: Int = 0
    private let introductionView = ReusableIntroductionView(
        backgroundImage: UIImage(named: "introduction"),
        title: "Welcome to Travel Buddy!",
        description: "Your road, your way, your buddy.",
        buttonTitle: "Get started",
        showPageControl: false
    )
    
    private let pages: [(title: String, description: String, buttonTitle: String)] = [
        (
            title: "What is Travel Buddy?",
            description: "Travel Buddy is your ultimate car travel companion! Plan efficient routes, track your journeys, and explore smarter with fuel and CO2 calculators. Keep your trips organized and save memories along the way. Let’s make every drive memorable!",
            buttonTitle: "Continue"
        ),
        (
            title: "Why Location Access?",
            description: "Travel Buddy uses your location to provide real-time navigation, find nearby gas stations, and show accurate traffic updates. Grant access to ensure the best travel experience wherever you go.",
            buttonTitle: "Continue"
        ),
        (
            title: "You’re all set!",
            description: "Enjoy exploring the app!",
            buttonTitle: "Start Now"
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(introductionView)
        
        configureIntroductionView()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            introductionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            introductionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            introductionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            introductionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureIntroductionView() {
        introductionView.translatesAutoresizingMaskIntoConstraints = false
        introductionView.actionButton.addAction(UIAction(handler: { [ weak self ] action in
            self?.handleActionButtonTap()
        }), for: .touchUpInside)
        introductionView.pageControl.isUserInteractionEnabled = false
    }
    
    private func handleActionButtonTap() {
        if currentPage < pages.count {
            let page = pages[currentPage]
            introductionView.titleLabel.text = page.title
            introductionView.descriptionLabel.text = page.description
            introductionView.actionButton.setTitle(page.buttonTitle, for: .normal)
            
            if currentPage == 0 {
                introductionView.pageControl.isHidden = false
            }
            
            introductionView.pageControl.currentPage = currentPage
            currentPage += 1
        } else {
        
        }
    }
}
