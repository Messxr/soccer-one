//
//  InformationViewController.swift
//  Soccer One
//
//  Created by Daniil Marusenko on 04.12.2020.
//

import UIKit

class AboutTeamViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var teamSchedule: [[String]] = [[],[]]
    var teamName: String?
    var teamAbout: String?
    var teamImage: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}


//MARK: - UITableViewDataSource

extension AboutTeamViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamSchedule[0].count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath) as! HeaderTeamCell
            cell.backgroundColor = .clear
            if let name = teamName, let image = teamImage, let about = teamAbout {
                cell.teamName.text = name
                cell.teamImage.image = UIImage(named: image)
                cell.teamInfo.text = about
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Middle", for: indexPath) as! MiddleScheduleCell
            if Double(Int(indexPath.row/2)) - Double(indexPath.row)/2.0 == 0 {
                cell.containerView.backgroundColor = UIColor(red: 0.10, green: 0.73, blue: 1.00, alpha: 1.00)
            } else {
                cell.containerView.backgroundColor = UIColor(red: 0.10, green: 0.46, blue: 1.00, alpha: 1.00)
            }
            cell.dateLabel.text = teamSchedule[0][indexPath.row - 1]
            cell.teamsLabel.text = teamSchedule[1][indexPath.row - 1]
            return cell
        }
    }

}
