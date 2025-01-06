//
//  TopNewsModel.swift
//  NewsApp
//
//  Created by Sushanth on 04/01/25.
//

import Foundation

struct TopNewsModel: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]
    
}

struct Article: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct Source: Codable {
    let id: String?
    let name: String?
}

actor TopNewsDataSource {
    private var topNewsList = [Article]()
    private var allNewsList = [Article]()
    func updateArticles(with newArticles: [Article]) {
        topNewsList = newArticles
    }

    func getArticles() -> [Article] {
        return topNewsList
    }
    
    func updateAllNewArticle(articles: [Article]) {
        allNewsList.append(contentsOf: articles)
    }
    
    func getAllNewsList() -> [Article] {
        return allNewsList
    }
    
    func resetDataONTabSwitch() {
        topNewsList = []
        allNewsList = []
    }
}
