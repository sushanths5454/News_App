//
//  TopNewsContianerViewTableViewCell.swift
//  NewsApp
//
//  Created by Sushanth on 03/01/25.
//

import UIKit

class TopNewsContianerViewTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    weak var delegate: HandleDetailScreenNavigation?
    var newsList = [Article]() {
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        registerCell()
       
    }
    
    func registerCell() {
        collectionView.register(UINib(nibName: "TopNewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TopNewsCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TopNewsContianerViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopNewsCollectionViewCell", for: indexPath) as? TopNewsCollectionViewCell {
            cell.newsList = newsList[safe: indexPath.row]
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showNewDetailsScreen(articel: newsList[safe: indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 180)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
          let pageWidth = collectionView.frame.width
          let currentPage = Int(collectionView.contentOffset.x / pageWidth)
          pageControl.currentPage = currentPage / (10 / 3)  
      }
    
}
