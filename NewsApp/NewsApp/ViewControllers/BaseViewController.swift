//
//  BaseViewController.swift
//  NewsApp
//
//  Created by Sushanth on 06/01/25.
//

import UIKit

class BaseViewController: UIViewController {

    var activityIndicator: UIActivityIndicatorView?
    lazy var refreshControl: UIRefreshControl = {[weak self] in
        guard let self = self else { return UIRefreshControl()}
        
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshController.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.backgroundcolor
        ])
        refreshController.tintColor = UIColor.backgroundcolor
        return refreshController
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            if self.activityIndicator == nil {
                self.activityIndicator = UIActivityIndicatorView(style: .large)
                self.activityIndicator?.color = UIColor.backgroundcolor
                self.activityIndicator?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.view.addSubview(self.activityIndicator!)
                self.activityIndicator?.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.height / 2)
            }
            self.activityIndicator?.startAnimating()
        }
    }
    
    func hideAcitivityIndicator() {
        DispatchQueue.main.async {
            if let activityIndicator = self.activityIndicator {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                self.activityIndicator = nil
            }
        }
    }
    
    @objc func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.refreshControl.endRefreshing()
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
