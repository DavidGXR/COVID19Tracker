//
//  UIColor.swift
//  COVIDTracker
//
//  Created by David Im on 23/3/21.
//

import Foundation
import UIKit

extension UIColor {
    
    static let universalGreen                   = UIColor().colorFromHex("03B715")
    static let universalYellow                  = UIColor().colorFromHex("F39C12")
    static let universalRed                     = UIColor().colorFromHex("FF0000")
    
    func colorFromHex (_ hex: String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            return UIColor.black
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                            green:  CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                            blue:  CGFloat(rgb & 0x0000FF) / 255.0,
                            alpha:  1)
    }
}

