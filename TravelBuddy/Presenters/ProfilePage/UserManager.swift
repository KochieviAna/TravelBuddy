//
//  UserManager.swift
//  TravelBuddy
//
//  Created by MacBook on 24.01.25.
//

import Foundation

final class UserManager {
    static let shared = UserManager()
    
    private init() {}
    
    @Published var isGuest: Bool = true
}
