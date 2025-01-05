//
//  BookMarkViewModel.swift
//  NewsApp
//
//  Created by Sushanth on 05/01/25.
//

import Foundation
class BookMarkViewModel {
    private var bookMarks: [Articles]?
    
    func getBookMarkedArticles() {
        do {
            bookMarks = try CoreDataManager.shared.context.fetch(Articles.fetchRequest()) as? [Articles]
        }catch {
            
        }
    }
    
    func numberOfRow() -> Int {
        return bookMarks?.count ?? 0
    }
    
    func getItemAtThe(index: Int) -> Articles? {
        return bookMarks?[safe: index]
    }
    
    func removeAtIndex(index: Int) {
        if let article = bookMarks?[safe: index] {
            CoreDataManager.shared.removeBookmarked(article: article)
        }
        bookMarks?.remove(at: index)
    }
}
