//
//  IntroductionVC.swift
//  TravelBuddy
//
//  Created by MacBook on 15.01.25.
//

import UIKit

final class IntroductionVC: UIViewController {
    
    private lazy var introductionView: ReusableIntroductionView = {
        let view = ReusableIntroductionView(
            backgroundImage: UIImage(named: "introduction"),
            title: "",
            description: "",
            buttonTitle: "",
            showPageControl: false
        )
        
        return view
    }()
    
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
            introductionView.topAnchor.constraint(equalTo: view.topAnchor),
            introductionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            introductionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            introductionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func updateUI() {
        let page = viewModel.currentPageData
        introductionView.titleLabel.text = page.title
        introductionView.descriptionLabel.text = page.description
        introductionView.actionButton.setTitle(page.buttonTitle, for: .normal)

        introductionView.titleLabel.font = UIFont.systemFont(ofSize: page.titleFontSize, weight: .bold)
        introductionView.descriptionLabel.font = UIFont.systemFont(ofSize: page.descriptionFontSize, weight: .regular)

        introductionView.pageControl.numberOfPages = viewModel.pages.count - 1

        introductionView.pageControl.currentPage = max(0, viewModel.currentPage - 1)

        introductionView.pageControl.isHidden = viewModel.currentPage == 0
    }
    
    private func handleActionButtonTap() {
        if viewModel.isLastPage {
            UserDefaults.standard.set(true, forKey: "hasSeenIntroduction")
            
            let signInVC = SignInVC()
            navigationController?.pushViewController(signInVC, animated: true)
        } else {
            viewModel.moveToNextPage { [weak self] in
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            }
        }
    }
}
