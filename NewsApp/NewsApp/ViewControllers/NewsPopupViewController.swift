//
//  NewsPopupViewController.swift
//  NewsApp
//
//  Created by Sushanth on 05/01/25.
//

import UIKit
import WebKit

class NewsPopupViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Loading the web view from the url
        if let url = url,
        let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
    }
}
