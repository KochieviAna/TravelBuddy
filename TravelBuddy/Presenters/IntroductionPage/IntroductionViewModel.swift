//
//  IntroductionViewModel.swift
//  TravelBuddy
//
//  Created by MacBook on 16.01.25.
//

import UIKit

final class IntroductionViewModel {
    private let pages = [
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
    
    private(set) var currentPage: Int = 0
    
    var currentPageData: (title: String, description: String, buttonTitle: String) {
        return pages[currentPage]
    }
    
    var isLastPage: Bool {
        return currentPage == pages.count - 1
    }
    
    func moveToNextPage() {
        if currentPage < pages.count - 1 {
            currentPage += 1
        }
    }
}
