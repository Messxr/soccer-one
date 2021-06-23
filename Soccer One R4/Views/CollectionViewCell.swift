//
//  CollectionViewCell.swift
//  Soccer One
//
//  Created by Daniil Marusenko on 04.12.2020.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var miniContainer: UIView!
    
    
    func setImage(_ urlString: String) {
        if let cachedData = CacheManager.getVideoCache(urlString) {
            self.cellImage.image = UIImage(data: cachedData)
            return
        }
        
        let url = URL(string: urlString)
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            if error == nil && data != nil {
                
                CacheManager.setVideoCache(url!.absoluteString, data)
                
                // Create the image object
                let image = UIImage(data: data!)
                
                //Set the ImageView
                DispatchQueue.main.async {
                    self.cellImage.image = image
                }
                
            }
        }
        task.resume()
    }
    
}
