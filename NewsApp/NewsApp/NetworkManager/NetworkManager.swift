//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Sushanth on 04/01/25.
//

import Foundation

class NetworkManager {
    static var shared  = NetworkManager()
    
    func fetchNewsItems(url: String) async throws -> [Article] {
        guard let url = URL(string: url) else {
             throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedList = try JSONDecoder().decode(TopNewsModel.self, from: data)
        return decodedList.articles
    }
}
