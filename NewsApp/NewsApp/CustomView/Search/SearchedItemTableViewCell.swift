//
//  SearchedItemTableViewCell.swift
//  NewsApp
//
//  Created by Sushanth on 05/01/25.
//

import UIKit

class SearchedItemTableViewCell: UITableViewCell {

    @IBOutlet weak var iconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var clockIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
