//
//  MenuViewController.swift
//  Soccer One
//
//  Created by Daniil Marusenko on 04.12.2020.
//

import UIKit

enum MenuType: Int {
    case teams
    case players
    case articles
    case settings
}

class MenuViewController: UITableViewController {

    var didTapMenuType: ((MenuType) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        dismiss(animated: true) { [weak self] in
            print("Dismissing: \(menuType)")
            self?.didTapMenuType?(menuType)
        }
    }
}
