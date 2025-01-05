//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Sushanth on 04/01/25.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var newsTitle: UILabel!
    
    weak var delegate: HandleShareNews?
    var newsItem: Article? {
        didSet {
            Task {
               await updateCellContent()
            }
        }
    }
    
    var bookMarkedArticle: Articles? {
        didSet {
            Task {
               await updateCellContent()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
        
        self.containerView.layer.cornerRadius = 20
        self.containerView.clipsToBounds = true
        self.thumbnailImage.layer.cornerRadius = 20
        self.thumbnailImage.layer.masksToBounds = true
        
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage.image =  UIImage(named: "loadingIndicator")
    }
    
    //MARK: cell values update
    func updateCellContent() async {
        if let newsItem = newsItem {
            newsTitle.text = newsItem.title
            await thumbnailImage.loadImageFromURL(url: newsItem.urlToImage ?? "")
        } else if let newsItem = bookMarkedArticle {
            newsTitle.text = newsItem.title
            await thumbnailImage.loadImageFromURL(url: newsItem.urlToImage ?? "")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: Share
    @IBAction func shareTapped(_ sender: UIButton) {
        if let newsItem = newsItem {
            delegate?.shareNews(sender: sender, article: newsItem)
        }
    }

}
