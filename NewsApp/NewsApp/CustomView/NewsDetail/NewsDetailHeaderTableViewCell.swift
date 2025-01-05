//
//  NewsDetailHeaderTableViewCell.swift
//  NewsApp
//
//  Created by Sushanth on 04/01/25.
//

import UIKit

class NewsDetailHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var publisherName: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
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
        viewSetup()
        self.containerView.layer.cornerRadius = 35
        self.containerView.layer.masksToBounds = true
       
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
      
        // Initialization code
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

    
    func viewSetup() {
  
        
       // setGradientBackground()
    }
    
    func setGradientBackground() {
         
    

           let colorTop = UIColor.tertiaryLabel.withAlphaComponent(0)
           let colorBottom = UIColor.tertiaryLabel.withAlphaComponent(1)
           
   
           gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
           
 
           let gradientLayer = CAGradientLayer()
           gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
           gradientLayer.locations = [0.0, 1.0]
           
 
        gradientLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y,
                                         width: bounds.size.width, height: bounds.size.height)
           

           gradientView.layer.insertSublayer(gradientLayer, at: 0)
       }
    
    
}
