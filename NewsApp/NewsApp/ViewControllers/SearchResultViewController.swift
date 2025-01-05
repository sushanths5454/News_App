//
//  SearchResultViewController.swift
//  NewsApp
//
//  Created by Sushanth on 05/01/25.
//

import UIKit

enum ResultType: Int, CaseIterable {
    case previousSearches = 0
    case ongoingSearches = 1
}

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var results: UITableView!
    
    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        results.delegate = self
        results.dataSource = self
        registerCell()
    }
    
    //MARK: Register the cell
    func registerCell() {
        results.register(UINib(nibName: "SearchedItemTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchedItemTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.loadSearchHistory()
    }
    
    //MARK: Fetched and update searched string item
    func reloadContent(query: String) {
        viewModel?.filterSearchedResult(query: query)
        results.reloadData()
    }
    
    //MARK: Detail page Navigation
    private func showDetailScreen(article: Article?) {
        let detailVC = NewsDetailViewController()
        detailVC.article = article
        detailVC.modalPresentationStyle = .fullScreen
        if let viewController = self.parent {
            viewController.present(detailVC, animated: true, completion: nil)
        }
    }
}

extension SearchResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Tableview - Number of section
    func numberOfSections(in tableView: UITableView) -> Int {
        return ResultType.allCases.count
    }
    
    //MARK: Tableview - Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ResultType(rawValue: section) {
        case .ongoingSearches:
            return viewModel?.ongoingSearches.count ?? 0
        case .previousSearches:
            return viewModel?.previousSearches.count ?? 0
        default:
            return 0
        }
    }
    
    //MARK: Tableview - cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchedItemTableViewCell", for: indexPath) as? SearchedItemTableViewCell {
            switch ResultType(rawValue: indexPath.section) {
            case .ongoingSearches:
                cell.iconWidthConstraint.constant = 0
                cell.title.text =  viewModel?.ongoingSearches[safe: indexPath.row] ?? ""
            case .previousSearches:
                cell.iconWidthConstraint.constant = 25
                cell.title.text =  viewModel?.previousSearches[safe: indexPath.row] ?? ""
            default:
                break
            }
            return cell
            
        }
        return UITableViewCell()
    }
    
    //MARK: Tableview - Did select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.saveSearchHistory(query:viewModel?.ongoingSearches[safe: indexPath.row] ?? "")
        showDetailScreen(article: viewModel?.getFilterArticleAt(index: indexPath.row))
    }
    

}
