//
//  AppIntrodViewcontroller.swift
//  NewsApp
//
//  Created by Sushanth on 03/01/25.
//

import Foundation

class AppIntrodViewModel {
    private var title = [
        "Stay Informed",
        "Personalized News",
        "Real-Time Updates"
    ]
    private var subTitle = [
        "Get the latest headlines and breaking news from trusted sources around the world",
        "Tailor your news feed to your interests with personalized topics and categories",
        "Receive real-time notifications on important events and breaking news as they happen"
    ]
    
    func getElementsCount() -> Int{
        return title.count
    }
    
    func getTitleForTheIndex(index: Int) -> String {
        return title[safe: index] ?? ""
    }
    
    func getSubTitleForTheIndex(index: Int) -> String {
        return subTitle[safe: index] ?? ""
    }
}
