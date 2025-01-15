//
//  Font+Extension.swift
//  TravelBuddy
//
//  Created by MacBook on 15.01.25.
//

import SwiftUI

extension Font {
    static func robotoBold(size: CGFloat) -> Font {
        return Font.custom("Roboto-Bold", size: size)
    }
    
    static func robotoLight(size: CGFloat) -> Font {
        return Font.custom("Roboto-Light", size: size)
    }
    
    static func robotoMedium(size: CGFloat) -> Font {
        return Font.custom("Roboto-Medium", size: size)
    }
    
    static func robotoRegular(size: CGFloat) -> Font {
        return Font.custom("Roboto-Regular", size: size)
    }
    
    static func robotoSemiBold(size: CGFloat) -> Font {
        return Font.custom("Roboto-SemiBold", size: size)
    }
}
