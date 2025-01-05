//
//  UIString+Extension.swift
//  NewsApp
//
//  Created by Sushanth on 03/01/25.
//

import Foundation
import UIKit
extension String {
    // Method to calculate the width of a string based on the font and max width
    func calculateWidth(font: UIFont, maxWidth: CGFloat) -> CGFloat {
        let size = (self as NSString).boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                                                   options: .usesLineFragmentOrigin,
                                                   attributes: [.font: font],
                                                   context: nil)
        return size.width
    }
    
     
}
