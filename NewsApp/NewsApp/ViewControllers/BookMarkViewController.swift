//
//  BookMarkViewController.swift
//  NewsApp
//
//  Created by Sushanth on 05/01/25.
//

import UIKit

class BookMarkViewController: BaseViewController {
    //MARK: IBOutlet
    @IBOutlet weak var noBookMarkMsg: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = BookMarkViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerCell()
        NavigatiobBarSetup()
        noBookMarkMsg.isHidden = true
        tableView.refreshControl = refreshControl
        // Do any additional setup after loading the view.
    }
    
    //MARK: Cell register
    private func registerCell() {
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
    }
    
    //MARK: Navigation Bar setup
    private func NavigatiobBarSetup() {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getBookMarkedArticles()
        noBookMarkMsg.isHidden = viewModel.numberOfRow() == 0 ? false : true
        tableView.reloadData()
    }
    
    //MARK: Pull to refresh
    override func refreshData() {
        viewModel.getBookMarkedArticles()
        noBookMarkMsg.isHidden = viewModel.numberOfRow() == 0 ? false : true
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.refreshControl.endRefreshing()
        })
    }
    
    //MARK: Navigation - Detail page
    private func showDetailScreen(article: Articles?) {
        let detailVC = NewsDetailViewController()
        detailVC.bookMarkedArticle = article
        detailVC.sourceType = .bookmark
        detailVC.modalPresentationStyle = .fullScreen
        if let viewController = self.parent {
            viewController.present(detailVC, animated: true, completion: nil)
        }
    }
}

extension BookMarkViewController: UITableViewDataSource, UITableViewDelegate {
    
   //MARK: Tableview - Number of rows
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRow()
    }
    
    //MARK: Tableview - cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell {
            cell.bookMarkedArticle = viewModel.getItemAtThe(index: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: Tableview - Row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //MARK: Tableview - Did select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetailScreen(article: viewModel.getItemAtThe(index: indexPath.row))
    }
    
    //MARK: Tableview - Swipe delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      
        let bookMarkAction = UIContextualAction(style: .normal, title: "Delete") { [weak self](action, view, completionHandler) in
            
            self?.viewModel.removeAtIndex(index: indexPath.row)
            tableView.reloadData()
            self?.noBookMarkMsg.isHidden = self?.viewModel.numberOfRow() == 0 ? false : true
            completionHandler(true)
        }
        bookMarkAction.backgroundColor = .red

        let swipeActions = UISwipeActionsConfiguration(actions: [ bookMarkAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions
    }
}
