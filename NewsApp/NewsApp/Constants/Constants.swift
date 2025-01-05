//
//  Constants.swift
//  NewsApp
//
//  Created by Sushanth on 04/01/25.
//

import Foundation
class Constants {
    
    private static let baseURL = "https://newsapi.org/v2/"
    private static let apiKey = "a0ae51f3736340a79d0081f07d15c834"
    private static let country =  "us"
    
    static let topNewsURL = "https://newsapi.org/v2/top-headlines?country=us&category=Business&apiKey=a0ae51f3736340a79d0081f07d15c834"
    static let allNewsURL = "https://newsapi.org/v2/everything?q=Business&from=2024-12-05&sortBy=publishedAt&apiKey=a0ae51f3736340a79d0081f07d15c834&page=1"
    
    static func getURL(type: HomePageSection, category: String) -> String {
        switch type {
        case .topNews:
            return "\(baseURL)top-headlines?country=\(country)&category=\(category)&apiKey=\(apiKey)"
        case .allNews:
            let today = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let formattedDate = dateFormatter.string(from: today)
            return "\(baseURL)everything?q=\(category)&from=2024-12-05&sortBy=publishedAt&apiKey=\(apiKey)"
        }
    }
}
