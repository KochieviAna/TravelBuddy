//
//  ReusableBackButton.swift
//  TravelBuddy
//
//  Created by MacBook on 17.01.25.
//

import UIKit

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
