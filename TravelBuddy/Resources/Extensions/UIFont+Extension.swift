//
//  UIFont+Extension.swift
//  TravelBuddy
//
//  Created by MacBook on 15.01.25.
//

import UIKit

extension UIFont {
    static func robotoBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
    }
    
    static func robotoLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Light", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }
    
    static func robotoMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }
    
    static func robotoRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }
    
    static func robotoSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-SemiBold", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }
}
