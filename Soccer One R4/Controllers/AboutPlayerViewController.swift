//
//  PlayerInfoViewController.swift
//  Soccer One
//
//  Created by Daniil Marusenko on 04.12.2020.
//

import UIKit

class AboutPlayerViewController: UIViewController {

    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerTextView: UITextView!
    @IBOutlet weak var playerNameLabel: UILabel!
    
    var playerImage: String?
    var playerName: String?
    var playerInfo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playerImageView.layer.cornerRadius = 25
        playerImageView.layer.shadowColor = UIColor.black.cgColor
        playerImageView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        playerImageView.layer.shadowOpacity = 0.2
        playerImageView.layer.shadowRadius = 3
        
        if let image = playerImage, let name = playerName, let info = playerInfo {
            setImage(image)
            playerTextView.text = info
            playerNameLabel.text = name
        }
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func setImage(_ urlString: String) {
        if let cachedData = CacheManager.getVideoCache(urlString) {
            self.playerImageView.image = UIImage(data: cachedData)
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
                    self.playerImageView.image = image
                }
                
            }
        }
        task.resume()
    }

}
