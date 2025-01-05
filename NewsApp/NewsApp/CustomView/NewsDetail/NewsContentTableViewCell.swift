//
//  NewsContentTableViewCell.swift
//  NewsApp
//
//  Created by Sushanth on 04/01/25.
//

import UIKit
import WebKit

class NewsContentTableViewCell: UITableViewCell {
   
    @IBOutlet weak var publishedBy: UILabel!
    @IBOutlet weak var title: UILabel!

    
    @IBOutlet weak var publishedDate: UILabel!
    
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    var article: Any? {
        didSet {
            updateCellContent()
            //loadWebViewContent()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCellUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellUI() {
       
       
//        self.contentView.layer.cornerRadius = 35
//        self.contentView.layer.masksToBounds = true
       // self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      //  self.contentView.layer.masksToBounds = true
    }
    
    func updateCellContent() {
        if let article = article as? Article {
            contentTitle.text = article.description ?? ""
            title.text = article.title ?? ""
            publishedBy.text = "Published By: \(article.author ?? "")"
            publishedDate.text = "Published: \(article.publishedAt)"
        } else if let article = article as? Articles {
            contentTitle.text = article.descriptions ?? ""
            title.text = article.title ?? ""
            publishedBy.text = "Published By: \(article.author ?? "")"
            publishedDate.text = "Published: \(article.publishedAt ?? "")"
        }
    }
    
    func loadWebViewContent() {
        
//        if let url = article?.url,
//           let url = URL(string: url) {
//            webview.load(URLRequest(url: url))
//        }
        
    }
    
}
