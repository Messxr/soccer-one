//
//  SupportViewController.swift
//  Soccer One
//
//  Created by Daniil Marusenko on 04.12.2020.
//

import UIKit
import StoreKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    let transiton = SlideInTransition()
    var topView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        updateButton(rateButton)
        updateButton(supportButton)
        updateButton(privacyPolicyButton)
    }
    
    @IBAction func rateButtonPressed(_ sender: UIButton) {
        rateApp()
    }
    
    @IBAction func supportButtonPressed(_ sender: UIButton) {
        if let url = URL(string: "") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func privacyPolicyPressed(_ sender: UIButton) {
        if let url = URL(string: "") {
            UIApplication.shared.open(url)
        }
    }
    
    func rateApp() {
        
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
            
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "appId") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    
    func updateButton(_ button: UIButton) {
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 2
    }
    
}

//MARK: - SideMenu

extension SettingsViewController {
    
    @IBAction func didTapMenu(_ sender: UIButton) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        menuViewController.didTapMenuType = { menuType in
            self.transitionToNew(menuType)
        }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }

    func transitionToNew(_ menuType: MenuType) {
        let title = String(describing: menuType).capitalized
        self.title = title

        topView?.removeFromSuperview()
        switch menuType {
        case .teams:
            guard let childVC = self.storyboard?.instantiateViewController(withIdentifier: "Teams") else { return }
            view.addSubview(childVC.view)
            self.topView = childVC.view
            addChild(childVC)
            self.title = "Clubs"
        case .players:
            guard let childVC = self.storyboard?.instantiateViewController(withIdentifier: "Players") else { return }
            view.addSubview(childVC.view)
            self.topView = childVC.view
            addChild(childVC)
        case .articles:
            guard let childVC = self.storyboard?.instantiateViewController(withIdentifier: "Articles") else { return }
            view.addSubview(childVC.view)
            self.topView = childVC.view
            addChild(childVC)
            self.title = "News"
        case .settings:
            guard let childVC = self.storyboard?.instantiateViewController(withIdentifier: "Settings") else { return }
            view.addSubview(childVC.view)
            self.topView = childVC.view
            addChild(childVC)
        }
    }

}

//MARK: - UIViewControllerTransitioningDelegate

extension SettingsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}
