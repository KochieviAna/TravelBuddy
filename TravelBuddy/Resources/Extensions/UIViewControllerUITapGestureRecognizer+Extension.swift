//
//  UIViewControllerUITapGestureRecognizer+Extension.swift
//  TravelBuddy
//
//  Created by MacBook on 19.01.25.
//

import UIKit

extension UIViewController {
    func enableTapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Allows other touch events to be processed
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
