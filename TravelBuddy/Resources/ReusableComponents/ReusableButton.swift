//
//  ReusableButton.swift
//  TravelBuddy
//
//  Created by MacBook on 17.01.25.
//

import UIKit
import SwiftUI

final class ReusableButton: UIButton {
    
    init(
        title: String,
        action: @escaping () -> Void
    ) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(.primaryWhite, for: .normal)
        self.titleLabel?.font = .robotoRegular(size: 25)
        self.backgroundColor = .deepBlue
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        self.addAction(UIAction(handler: { _ in
            action()
        }), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct ReusableButtonWrapper: UIViewRepresentable {
    var title: String
    var action: () -> Void

    func makeUIView(context: Context) -> ReusableButton {
        ReusableButton(title: title, action: action)
    }

    func updateUIView(_ uiView: ReusableButton, context: Context) { }
}
