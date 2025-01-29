//
//  ForgotPasswordViewControllerWrapper.swift
//  TravelBuddy
//
//  Created by MacBook on 29.01.25.
//

import SwiftUI

struct ForgotPasswordViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ForgotPasswordVC {
        return ForgotPasswordVC()
    }

    func updateUIViewController(_ uiViewController: ForgotPasswordVC, context: Context) {}
}
