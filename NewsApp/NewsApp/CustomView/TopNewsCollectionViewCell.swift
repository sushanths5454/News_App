//
//  TopNewsCollectionViewCell.swift
//  NewsApp
//
//  Created by Sushanth on 03/01/25.
//

import UIKit

class TopNewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    var newsList: Article? {
        didSet {
            Task {
               await updateCellContent()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        self.contentView.layer.cornerRadius = 35
        self.contentView.layer.masksToBounds = true
        self.thumbnailImage.layer.shadowColor = UIColor.white.cgColor
        self.thumbnailImage.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.thumbnailImage.layer.shadowOpacity = 0.2
        self.thumbnailImage.layer.shadowRadius = 4
        self.thumbnailImage.layer.masksToBounds = false
    }
    
    func updateCellContent() async {
        if let article = newsList {
            title.text = article.title
            await thumbnailImage.loadImageFromURL(url: article.urlToImage ?? "")
        }
    }
}
