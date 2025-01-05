//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Sushanth on 04/01/25.
//

import UIKit

enum SourceType {
    case home
    case bookmark
}

class NewsDetailViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var bookMarkButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var article: Article?
    var bookMarkedArticle: Articles?
    var isBookMarked = false
    var sourceType: SourceType = .home
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        registerCell()
        udateBookMarkdetail()
    }
    
    //MARK: Updating is Bookmarked article
    func udateBookMarkdetail() {
        switch sourceType {
        case .home:
            if let article = article {
                isBookMarked = CoreDataManager.shared.isArticleBookMarked(article: article)
                bookMarkButton.setImage(UIImage(systemName: isBookMarked ? "bookmark.fill" : "bookmark"), for: .normal)
            }
        case .bookmark:
           if let article = bookMarkedArticle {
               isBookMarked = CoreDataManager.shared.isArticleBookMarked(article: article)
               bookMarkButton.setImage(UIImage(systemName: isBookMarked ? "bookmark.fill" : "bookmark"), for: .normal)
           }
        }
    }
    
    //MARK: Cell register
    private func registerCell() {
        tableView.register(UINib(nibName: "NewsDetailHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsDetailHeaderTableViewCell")
        
        tableView.register(UINib(nibName: "NewsContentTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsContentTableViewCell")
        
    }

    //MARK: Bookmark icon Tapped
    @IBAction func bookMarked(_ sender: UIButton) {
        if isBookMarked {
            switch sourceType {
            case .home:
                if let article = article {
                    CoreDataManager.shared.removeBookmarked(article: article)
                }
            case .bookmark:
                if let article = bookMarkedArticle {
                    CoreDataManager.shared.removeBookmarked(article: article)
                }
            }
            
        } else {
        
            var bookMarkedArticles = Articles(context: CoreDataManager.shared.context)
            switch sourceType {
            case .home:
                if let article = article {
                    bookMarkedArticles.title = article.title ?? ""
                    bookMarkedArticles.id = article.source?.id ?? ""
                    bookMarkedArticles.content = article.content ?? ""
                    bookMarkedArticles.author = article.author ?? ""
                    bookMarkedArticles.publishedAt = article.publishedAt 
                    bookMarkedArticles.url = article.url ?? ""
                    bookMarkedArticles.urlToImage = article.urlToImage ?? ""
                    bookMarkedArticles.name = article.source?.name ?? ""
                }
            case .bookmark:
                if let article = bookMarkedArticle {
                    bookMarkedArticles = article
                }
            }

            CoreDataManager.shared.saveContext()
        }
        udateBookMarkdetail()
    }
    
    //MARK: Show web view
    @IBAction func readMore(_ sender: UIButton) {
        let detailViewController = NewsPopupViewController()
           
        if let url = article?.url {
            detailViewController.url = url
        }
        detailViewController.modalPresentationStyle = .pageSheet
        if let sheet = detailViewController.sheetPresentationController {
           sheet.detents = [
            .large(),
            .medium()
           ]
           sheet.selectedDetentIdentifier = .medium
        }
        present(detailViewController, animated: true, completion: nil)
    }
    
    //MARK: Back
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension NewsDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Tableview: number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    //MARK: Tableview: cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDetailHeaderTableViewCell", for: indexPath) as? NewsDetailHeaderTableViewCell {
                cell.article = sourceType == .home ? article : bookMarkedArticle
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsContentTableViewCell", for: indexPath) as? NewsContentTableViewCell {
                cell.article = sourceType == .home ? article : bookMarkedArticle
                return cell
            }
        }
        return UITableViewCell()
        
    }
    
    //MARK: Tableview: Row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 0.4 * UIScreen.main.bounds.height
        default:
            return UITableView.automaticDimension
        }

    }
}

