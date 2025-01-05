//
//  UIColor+Extension.swift
//  NewsApp
//
//  Created by Sushanth on 03/01/25.
//

import Foundation
import UIKit

extension UIColor {
    
    func getColorFrom(red: Float, green: Float, blue: Float) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
    }
}
