//
//  Array+Extension.swift
//  NewsApp
//
//  Created by Sushanth on 03/01/25.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
