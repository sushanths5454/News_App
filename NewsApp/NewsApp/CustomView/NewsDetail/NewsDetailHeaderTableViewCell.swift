//
//  NewsDetailHeaderTableViewCell.swift
//  NewsApp
//
//  Created by Sushanth on 04/01/25.
//

import UIKit

class NewsDetailHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var article: Any? {
        didSet {
            Task {
                await updateCellContent()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 35
        self.containerView.layer.masksToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    }
    
    func updateCellContent() async {
        if let newsItem = article as? Article {
            await backgroundImage.loadImageFromURL(url: newsItem.urlToImage ?? "")
        } else if let newsItem = article as? Articles {
            await backgroundImage.loadImageFromURL(url: newsItem.urlToImage ?? "")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
