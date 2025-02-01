//
//  ReusableBackButton.swift
//  TravelBuddy
//
//  Created by MacBook on 17.01.25.
//

import UIKit
import SwiftUI

final class ReusableBackButton: UIButton {
    
    init(action: @escaping () -> Void) {
        super.init(frame: .zero)
        
        self.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        self.tintColor = .deepBlue
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addAction(UIAction(handler: { _ in
            action()
        }), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct ReusableBackButtonWrapper: UIViewRepresentable {
    let action: () -> Void

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .deepBlue
        button.addTarget(context.coordinator, action: #selector(Coordinator.backButtonTapped), for: .touchUpInside)
        return button
    }

    func updateUIView(_ uiView: UIButton, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }

    class Coordinator {
        let action: () -> Void

        init(action: @escaping () -> Void) {
            self.action = action
        }

        @objc func backButtonTapped() {
            action()
        }
    }
}
