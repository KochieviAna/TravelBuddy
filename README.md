**Travel Buddy**


**Overview**

Travel Buddy is an iOS application that I have designed for frequent travelers, particularly those who drive. The app provides features like trip planning, optimized route selection, fuel and CO2 tracking, and trip archives. It integrates Firebase for authentication and data storage while using both UIKit and SwiftUI for the user interface.


**Features**

Trip Planning: Users can set destinations and plan trips efficiently.

Fuel and CO2 Calculations: Track fuel consumption and CO2 emissions based on vehicle details.

Trip History & Archives: Users can store and review past trips.

Multi-Language Support: Supports English and Georgian.


**Technologies Used**

UIKit: Used for navigation, authentication screens, and general app structure.

SwiftUI: Implemented for certain views like trip statistics and journey details.

Firebase: Used for user authentication and data storage.

Core Location: Provides location tracking for navigation and route planning.

MapKit: Displays maps and routes.

UIKit and SwiftUI Integration

The app leverages a hybrid approach:

UIKit:

AppDelegate.swift and SceneDelegate.swift manage app lifecycle and navigation.

View controllers (e.g., SignInVC.swift, ForgotPasswordVC.swift) handle authentication and onboarding.

TabBarController.swift controls the main navigation flow.

Various reusable components like ReusableButton.swift and ReusableLabelAndTextFieldView.swift enhance UI consistency.

SwiftUI:

Views like StatisticsView.swift, JourneysView.swift, and ProfileView.swift provide a modern UI experience.

SwiftUI views are embedded inside UIKit using UIHostingController where needed.



**Setup & Installation**

Prerequisites

Xcode (latest version recommended)

CocoaPods (if using Firebase)

Swift 5+


**Installation Steps**

Clone the repository:

git clone https://github.com/KochieviAna/TravelBuddy
cd TravelBuddy

Install dependencies:

pod install

Open TravelBuddy.xcworkspace in Xcode.

Configure Firebase:

Add your GoogleService-Info.plist file in the project root.

Build and run the project on a simulator or device.
