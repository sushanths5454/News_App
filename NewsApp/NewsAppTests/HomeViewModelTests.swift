//
//  HomeViewModelTests.swift
//  NewsAppTests
//
//  Created by Sushanth on 06/01/25.
//

import XCTest
@testable import NewsApp

class MockNetworkManager: NetworkManager{
    override func fetchNewsItems(url: String) async throws -> [Article] {
        return [
            Article(source: Source(id: "1", name: "Test"), author: "Sushanth", title: "Top News", description: "Todays top news", url: "wwww.test.com", urlToImage: "www.image.com", publishedAt: "Today", content: "123"),
            Article(source: Source(id: "1", name: "Test"), author: "Sushanth", title: "Top News1", description: "Todays top news", url: "wwww.test.com", urlToImage: "www.image.com", publishedAt: "Today", content: "123"),
            Article(source: Source(id: "1", name: "Test"), author: "Sushanth", title: "Top News", description: "Todays top news", url: "wwww.test.com", urlToImage: "www.image.com", publishedAt: "Today", content: "123")
        ]
    }
}

final class HomeViewModelTests: XCTestCase {
    
    var vm: HomeViewModel!
    var mockNetworkManager: MockNetworkManager!
    @MainActor override  func setUp() {
        super.setUp()
        NetworkManager.shared = MockNetworkManager()
        vm = HomeViewModel()
    }

    override func tearDown() {
        vm = nil
        super.tearDown()
    }
    
    @MainActor func testInitailState() async  {
        
        await vm.fetchTopNewsItems()
        await vm.fetchAllNewsItems()
        
        XCTAssertNotNil(vm, "The view model should be initialized")
        
        XCTAssertEqual(vm.numberOfRows(section: 0), 1)
        
        XCTAssertEqual(vm.getNewsList().count, 3)
        XCTAssertEqual(vm.getNewsList()[0].title , "Top News")
        
        XCTAssertEqual(vm.numberOfRows(section: 1), 3)
        XCTAssertEqual(vm.getAllNewsItem(atIndex: 1)?.title, "Top News1")
        
        
    }
    
    @MainActor func testSaveSearchHistory() {
        vm.saveSearchHistory(query: "New Search1")
        vm.saveSearchHistory(query: "New Search2")
        vm.saveSearchHistory(query: "New Search3")
        vm.saveSearchHistory(query: "New Search4")
        vm.saveSearchHistory(query: "New Search5")
        vm.saveSearchHistory(query: "New Search6")
        
        XCTAssertEqual(vm.previousSearches.first, "New Search1")
        XCTAssertEqual(vm.previousSearches.last, "New Search6")
        XCTAssertEqual(vm.previousSearches.count, 6)
    }
    
    @MainActor func testSearchFilterItems() async {
        await vm.fetchAllNewsItems()
        
        vm.filterSearchedResult(query: "Top News1")
        
        XCTAssertEqual(vm.ongoingSearches.count, 1)
        XCTAssertEqual(vm.getFilterArticleAt(index: 0)?.title, "Top News1")
        
    }
    
    func testHandleArticleBookMark() async {
        await vm.fetchAllNewsItems()
        await vm.handleArticleBookMark(index: 0)
        
        let isBookMarked = await CoreDataManager.shared.isArticleBookMarked(article: vm.getAllNewsItem(atIndex: 0)!)
        
        XCTAssertTrue(isBookMarked)
    }

}
