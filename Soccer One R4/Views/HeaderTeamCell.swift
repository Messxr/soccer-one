//
//  HeaderTeamCell.swift
//  Soccer One
//
//  Created by Daniil Marusenko on 04.12.2020.
//

import UIKit

class HeaderTeamCell: UITableViewCell {
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var teamInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 25
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
