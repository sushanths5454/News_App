//
//  CategoryHeaderCollectionViewCell.swift
//  NewsApp
//
//  Created by Sushanth on 03/01/25.
//

import UIKit

class CategoryHeaderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var indicatorView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    var isSelectedCategory: Bool = false{
        didSet {
            indicatorView.isHidden = !isSelectedCategory
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 19)
    }
    
    

}
