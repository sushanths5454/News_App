//
//  HomeTabViewController.swift
//  NewsApp
//
//  Created by Sushanth on 03/01/25.
//

import UIKit

class HomeTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    func setupViewController() {
        self.tabBar.shadowImage = UIImage()
    }
}
