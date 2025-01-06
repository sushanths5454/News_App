//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Sushanth on 03/01/25.
//

import Foundation

enum HomePageSection: Int, CaseIterable {
    case topNews = 0
    case allNews = 1
}

enum CategoryHeaderItems: Int, CaseIterable {
    case general = 0
    case business = 1
    case science = 2
    case technology = 3
    case health = 4
    case entertainment = 5
    case sport = 6
    
    func headerName() -> String {
        switch self {
        case .general:
            return "General"
        case .business:
            return "Business"
        case .science:
            return "Science"
        case .technology:
            return "Technology"
        case .health:
            return "Health"
        case .entertainment:
            return "Entertainment"
        case .sport:
            return "Sports"
        }
    }
}
@MainActor
class HomeViewModel {
    var selectedCategoryHeader = 0
    private var topsNewsDatasource = TopNewsDataSource()
    private var topNewList = [Article]()
    var allNewsList = [Article]()
    
    private var filteredNewsArticles = [Article]()
    
    private var savedArticles = [Article]()
    
    var ongoingSearches = [String]()
    var previousSearches = [String]()
    var page = 1
    var isLoading = false
    var isMoreDataPresent = true
    
    func numberOfRows(section: Int) -> Int {
        switch HomePageSection(rawValue: section) {
        case .allNews:
            return allNewsList.count
        case .topNews:
            return 1
        case .none:
            return 1
        }
    }
    
    //MARK: API CAll - Top news items
    func fetchTopNewsItems() async {
        do {
            let articles = try await NetworkManager.shared.fetchNewsItems(url: Constants.getURL(type: .topNews, category: CategoryHeaderItems(rawValue: selectedCategoryHeader)?.headerName() ?? ""))
            await topsNewsDatasource.updateArticles(with: articles)
            self.topNewList = await topsNewsDatasource.getArticles()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: API CAll - All news items
    func fetchAllNewsItems() async {
        if !isLoading && isMoreDataPresent {
            do {
                isLoading = true
                var url = Constants.getURL(type: .allNews, category: CategoryHeaderItems(rawValue: selectedCategoryHeader)?.headerName() ?? "")
                url = url + "&page=\(page)"
                let articles = try await NetworkManager.shared.fetchNewsItems(url: url)
                await topsNewsDatasource.updateAllNewArticle(articles: articles)
                await allNewsList = topsNewsDatasource.getAllNewsList()
                isLoading = false
                isMoreDataPresent = true
                page += 1
            } catch {
                isLoading = false
                isMoreDataPresent = false
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: Reset data on pull to refresh and tab switch
    func resetAllDataOnTabSwtich() async {
        allNewsList = []
        topNewList = []
        await topsNewsDatasource.resetDataONTabSwitch()
    }
    
   // MARK: Top News list count
    func getNewsList() -> [Article] {
        return topNewList
    }
    
    //MARK: ALL News item count
    func getAllNewsItem(atIndex: Int) -> Article? {
        return allNewsList[safe: atIndex]
    }
    
    //MARK: Fetching searched articles
    func loadSearchHistory() {
       if let savedHistory = UserDefaults.standard.array(forKey: "searchHistory") as? [String] {
           previousSearches = savedHistory
       }
        loadSavedArticleFromUserDefaults()
    }
    
    //MARK: Saving searched articles
    func saveSearchHistory(query: String) {
         
       if !query.isEmpty && !previousSearches.contains(query) {
           previousSearches.append(query)
           UserDefaults.standard.set(previousSearches, forKey: "searchHistory")
       }
    }
    
    //MARK: Save article in the user defaults
    func saveArticleToUserDefaults(article: Article) {
        savedArticles.append(article)
           do {
               let encoder = JSONEncoder()
               let data = try encoder.encode(savedArticles)
               UserDefaults.standard.set(data, forKey: "saveArticles")
           } catch {
               print("Failed to encode topNewList: \(error.localizedDescription)")
           }
       }
       
    //MARK: Loading the article from the user defaults
   func loadSavedArticleFromUserDefaults() {
       if let data = UserDefaults.standard.data(forKey: "saveArticles") {
           do {
               let decoder = JSONDecoder()
               let articles = try decoder.decode([Article].self, from: data)
               self.savedArticles = articles
           } catch {
               print("Failed to decode topNewList: \(error.localizedDescription)")
           }
       }
   }
    
    //MARK: Updating articles list based on the query(Searched text)
    func filterSearchedResult(query: String) {
        
        if query.isEmpty {
             return
        }else {
            filteredNewsArticles = allNewsList.filter { article in
                guard let title = article.title else { return false }
                return title.lowercased().contains(query.lowercased())
            }
            .prefix(10) // Only top 10 items will show
            .map { $0 }
            ongoingSearches = filteredNewsArticles.map { $0.title ?? "" }
        }
    }
    
    //MARK: Searched Artcile
    func getFilterArticleAt(index: Int) -> Article? {
        return filteredNewsArticles[safe: index]
    }
    
    func getSavedArticleAt(index: Int) -> Article? {
        return savedArticles[safe: index]
    }
    
    //MARK: Add/Delete article from core data on swipe action
    func handleArticleBookMark(index: Int) {
        var bookMarkedArticles = Articles(context: CoreDataManager.shared.context)
      
        if let article = allNewsList[safe: index] {
            if CoreDataManager.shared.isArticleBookMarked(article: article) {
                CoreDataManager.shared.removeBookmarked(article: article)
            } else {
                bookMarkedArticles.title = article.title ?? ""
                bookMarkedArticles.id = article.source?.id ?? ""
                bookMarkedArticles.content = article.content ?? ""
                bookMarkedArticles.author = article.author ?? ""
                bookMarkedArticles.publishedAt = article.publishedAt
                bookMarkedArticles.url = article.url ?? ""
                bookMarkedArticles.urlToImage = article.urlToImage ?? ""
                bookMarkedArticles.name = article.source?.name ?? ""
            }
        }
    }
}
