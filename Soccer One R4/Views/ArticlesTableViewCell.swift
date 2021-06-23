//
//  ArticlesTableViewCell.swift
//  Treasure Hunter
//
//  Created by Daniil Marusenko on 06.12.2020.
//

import UIKit

class ArticlesTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleName: UILabel!
    @IBOutlet weak var articleInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImage(_ urlString: String) {
        if let cachedData = CacheManager.getVideoCache(urlString) {
            self.articleImage.image = UIImage(data: cachedData)
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
                    self.articleImage.image = image
                }
                
            }
        }
        task.resume()
    }

}
