//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Sushanth on 03/01/25.
//

import UIKit

protocol HandleShareNews: AnyObject {
    func shareNews(sender: UIButton, article: Article)
}

protocol HandleDetailScreenNavigation: AnyObject{
    func showNewDetailsScreen(articel: Article?)
}

class HomeViewController: BaseViewController {
    //MARK: IBOutlet
    @IBOutlet weak var categoryHeader: UICollectionView!
    @IBOutlet weak var tableview: UITableView!
    
    var viewModel = HomeViewModel()
    var searchController = UISearchController(searchResultsController: SearchResultViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        categoryHeader.delegate = self
        categoryHeader.dataSource = self
        
        registerTableViewCell()
        fetchNews()
        NavigationBarSetup()
        
        tableview.refreshControl = refreshControl
    
    }
    
    //MARK: Pull to refresh
    override func refreshData() {
        fetchNews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.refreshControl.endRefreshing()
        })
    }
    //MARK: Navigation Bar setup
    private func NavigationBarSetup() {
        if let navigationBar = self.navigationController?.navigationBar {
                  
            navigationBar.barTintColor = UIColor.white
            navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font:  UIFont(name: "HelveticaNeue-Bold", size: 23) ?? UIFont.systemFont(ofSize: 23)
            ]
            navigationBar.tintColor = .white
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        }
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        if let seatchResultController = searchController.searchResultsController as? SearchResultViewController {
            seatchResultController.viewModel = self.viewModel
        }
        
        let searchBar = searchController.searchBar
        searchBar.delegate = self
                searchBar.sizeToFit()
                searchBar.placeholder = "Search"
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        if #available(iOS 11.0, *) {

            self.navigationItem.searchController = searchController
        } else {
          
            navigationItem.titleView?.layoutSubviews()
        }
    }
    
    //MARK: Cell register
    private func registerTableViewCell() {
        
        categoryHeader.register(UINib(nibName: "CategoryHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryHeaderCollectionViewCell")
        tableview.register(UINib(nibName: "TopNewsContianerViewTableViewCell", bundle: nil), forCellReuseIdentifier: "TopNewsContianerViewTableViewCell")
        tableview.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
    }
    
    //MARK: API Call: Top News and All News
    private func fetchNews() {
           Task {
               await viewModel.resetAllDataOnTabSwtich()
               await (viewModel.fetchTopNewsItems(), viewModel.fetchAllNewsItems())
               tableview.reloadData()
               self.hideAcitivityIndicator()
           }
       }
  
    //MARK: Naviagtion to detailPage
    private func showDetailScreen(article: Article?) {
        let detailVC = NewsDetailViewController()
        detailVC.article = article
        detailVC.modalPresentationStyle = .fullScreen
        if let viewController = self.parent {
            viewController.present(detailVC, animated: true, completion: nil)
        }
    }
    
    private func loadMore() {
        Task {
            await viewModel.fetchAllNewsItems()
            tableview.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Tableview delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomePageSection.allCases.count
    }
    
    //MARK: Tableview - number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }
    
    //MARK: Tableview - cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch HomePageSection(rawValue: indexPath.section) {
        case .topNews:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TopNewsContianerViewTableViewCell", for: indexPath) as? TopNewsContianerViewTableViewCell {
                cell.newsList = viewModel.getNewsList()
                cell.delegate = self
                return cell
            }
            return UITableViewCell()
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell {
                cell.newsItem = viewModel.getAllNewsItem(atIndex: indexPath.row)
                cell.delegate = self
                return cell
            }
            return UITableViewCell()
        }
   }
    
    //MARK: Tableview - Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch HomePageSection(rawValue: indexPath.section) {
        case .topNews:
            return 200
        default:
            return 150
        }
    }
    
    //MARK: Tableview - didselect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if HomePageSection(rawValue: indexPath.section) == .topNews {
            return
        }
        showDetailScreen(article: viewModel.getAllNewsItem(atIndex: indexPath.row))
    }
    
    //MARK: Tableview - Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch HomePageSection(rawValue: indexPath.section) {
        case .topNews:
            return nil
        default:
            let bookMarkAction = UIContextualAction(style: .normal, title: "BookMark") { [weak self](action, view, completionHandler) in
                
                self?.viewModel.handleArticleBookMark(index: indexPath.row)
                completionHandler(true)
            }
            bookMarkAction.backgroundColor = .green

            let swipeActions = UISwipeActionsConfiguration(actions: [ bookMarkAction])
            swipeActions.performsFirstActionWithFullSwipe = false
            
            return swipeActions
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if HomePageSection(rawValue: indexPath.section) == .allNews && !viewModel.isLoading && viewModel.isMoreDataPresent && indexPath.row >= viewModel.numberOfRows(section: HomePageSection.allNews.rawValue) - 1 {
            loadMore()
        }
        
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//MARK: Collection View: Number of Items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryHeaderItems.allCases.count
    }
    
    //MARK: Collection View: cell for item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryHeaderCollectionViewCell", for: indexPath) as? CategoryHeaderCollectionViewCell {
            cell.isSelectedCategory  = viewModel.selectedCategoryHeader == indexPath.row
            cell.titleLabel.text = CategoryHeaderItems(rawValue: indexPath.row)?.headerName()
            return cell
        }
        return UICollectionViewCell()
    }
    
    //MARK: Collection View: size of Items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (CategoryHeaderItems(rawValue: indexPath.row)?.headerName().calculateWidth(font: UIFont(name: "HelveticaNeue-Bold", size: 19) ?? UIFont.systemFont(ofSize: 19), maxWidth: 19) ?? 20) + 50, height: 60)
    }
    
    //MARK: Collection View: did select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showActivityIndicator()
        viewModel.page = 1
        viewModel.isLoading = false
        viewModel.isMoreDataPresent = true
        viewModel.selectedCategoryHeader = indexPath.row
        fetchNews()
        categoryHeader.reloadData()
    }
}

extension HomeViewController: HandleShareNews {
    //MARK: Share article
    func shareNews(sender: UIButton,article: Article) {
        if let title = article.title, let urlInString = article.url {
            let shareText = "Check out this news article: \(title)"
            if let url = URL(string: urlInString) {
      
                let itemsToShare: [Any] = [shareText, url]
                let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
                
               
                if let popoverController = activityViewController.popoverPresentationController {
                    popoverController.sourceView = sender
                }
                
                if let viewController = self.parent {
                    viewController.present(activityViewController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension HomeViewController: HandleDetailScreenNavigation {
    //MARK: Detail screen Navigation
    func showNewDetailsScreen(articel: Article?) {
        showDetailScreen(article: articel)
    }
}

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    //MARK: Saerch delegates
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else { return }
        
        if let seatchResultController = searchController.searchResultsController as? SearchResultViewController {
            seatchResultController.reloadContent(query: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchBar.resignFirstResponder()
    }
    
}

