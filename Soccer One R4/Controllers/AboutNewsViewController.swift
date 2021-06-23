//
//  ArticleInfoViewController.swift
//  Soccer One
//
//  Created by Daniil Marusenko on 04.12.2020.
//

import UIKit

class AboutNewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var articleImage: String?
    var articleName: String?
    var articleDate: String?
    var articleInfo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - UITableViewDataSource

extension AboutNewsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrototypeCell", for: indexPath) as! ArticlesTableViewCell
        cell.backgroundColor = .clear
        if let image = articleImage, let name = articleName {
            cell.setImage(image)
            cell.articleName.text = name
            cell.articleInfo.text = articleInfo
        }
        return cell
    }

}
