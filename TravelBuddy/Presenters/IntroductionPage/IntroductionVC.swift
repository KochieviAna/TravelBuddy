//
//  IntroductionVC.swift
//  TravelBuddy
//
//  Created by MacBook on 15.01.25.
//

import UIKit

final class IntroductionVC: UIViewController {
    
    private let introductionView = ReusableIntroductionView(
        backgroundImage: UIImage(named: "introduction"),
        title: "",
        description: "",
        buttonTitle: "",
        showPageControl: false
    )
    
    private let viewModel = IntroductionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(introductionView)
        
        introductionView.translatesAutoresizingMaskIntoConstraints = false
        introductionView.actionButton.addAction(UIAction(handler: { [weak self] action in
            self?.handleActionButtonTap()
        }), for: .touchUpInside)
        
        introductionView.pageControl.isUserInteractionEnabled = false
        
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
    
    private func updateUI() {
        let page = viewModel.currentPageData
        introductionView.titleLabel.text = page.title
        introductionView.descriptionLabel.text = page.description
        introductionView.actionButton.setTitle(page.buttonTitle, for: .normal)
        introductionView.pageControl.isHidden = viewModel.currentPage == 0
        introductionView.pageControl.currentPage = viewModel.currentPage
    }
    
    private func handleActionButtonTap() {
        if viewModel.isLastPage {
            UserDefaults.standard.set(true, forKey: "hasSeenIntroduction")
            
            let signInVC = SignInVC()
            
            navigationController?.pushViewController(signInVC, animated: true)
        } else {
            viewModel.moveToNextPage()
            updateUI()
        }
    }
}
