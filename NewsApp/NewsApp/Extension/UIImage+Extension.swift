//
//  UIImage+Extension.swift
//  NewsApp
//
//  Created by Sushanth on 04/01/25.
//

import Foundation
import UIKit
extension UIImageView {
    
    func loadImageFromURL(url: String) async  {
        guard let url = URL(string: url) else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let image = UIImage(data: data) {
                self.image = image
            }
            
        } catch {
            
        }
    }
}
