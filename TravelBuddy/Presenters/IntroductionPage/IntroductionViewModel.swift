//
//  IntroductionViewModel.swift
//  TravelBuddy
//
//  Created by MacBook on 16.01.25.
//

import UIKit
import CoreLocation

final class IntroductionViewModel {
    
    let pages: [(title: String, description: String, buttonTitle: String, titleFontSize: CGFloat, descriptionFontSize: CGFloat)] = [
        (
            title: "Welcome to Travel Buddy!",
            description: "Your road, your way, your buddy.",
            buttonTitle: "Get Started",
            titleFontSize: 40.0,
            descriptionFontSize: 25.0
        ),
        (
            title: "What is Travel Buddy?",
            description: "Travel Buddy is your ultimate car travel companion! Plan efficient routes, track your journeys, and explore smarter with fuel and CO2 calculators. Keep your trips organized and save memories along the way. Let’s make every drive memorable!",
            buttonTitle: "Continue",
            titleFontSize: 40,
            descriptionFontSize: 18.0
        ),
        (
            title: "Why Location Access?",
            description: "Travel Buddy uses your location to provide real-time navigation, find nearby gas stations, and show accurate traffic updates. Grant access to ensure the best travel experience wherever you go.",
            buttonTitle: "Continue",
            titleFontSize: 40,
            descriptionFontSize: 18.0
        ),
        (
            title: "You’re all set!",
            description: "Enjoy exploring the app!",
            buttonTitle: "Start Now",
            titleFontSize: 40.0,
            descriptionFontSize: 25.0
        )
    ]
    
    private(set) var currentPage: Int = 0
    
    var shouldRequestLocation: Bool { return currentPage == 2 }
    
    var currentPageData: (title: String, description: String, buttonTitle: String, titleFontSize: CGFloat, descriptionFontSize: CGFloat) {
        let page = pages[currentPage]
        return (
            title: page.title,
            description: page.description,
            buttonTitle: page.buttonTitle,
            titleFontSize: page.titleFontSize,
            descriptionFontSize: page.descriptionFontSize
        )
    }
    
    var isLastPage: Bool {
        return currentPage == pages.count - 1
    }
    
    func moveToNextPage(completion: (() -> Void)? = nil) {
        if shouldRequestLocation {
            LocationManager.shared.requestLocationPermission { granted in
                DispatchQueue.main.async {
                    self.currentPage += 1
                    completion?()
                }
            }
        } else if currentPage < pages.count - 1 {
            currentPage += 1
            completion?()
        }
    }
}
