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
    
    func convertDateString() -> String? {
      
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = inputFormatter.date(from: self) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd-MM-yyyy"
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
     
}
