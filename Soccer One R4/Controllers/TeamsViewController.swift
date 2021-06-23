//
//  ViewController.swift
//  Soccer One
//
//  Created by Daniil Marusenko on 04.12.2020.
//

import UIKit
import UPCarouselFlowLayout

class TeamsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var jsonManager = JSONManager()
    var teamArray: [[String]] = []
    var teamIndex: Int?
    let transiton = SlideInTransition()
    var topView: UIView?
    
    fileprivate var currentPage: Int = 0 {
        didSet {
            jsonManager.getData(with: "https://messxr.github.io/SoccerOneTeams.json")
            while teamArray == [] { return }
            let team = teamArray[currentPage]
            nameLabel.text = team[0]
            cityLabel.text = team[1]
            infoLabel.text = team[5]
            collectionView.reloadData()
        }
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = 0
                
        jsonManager.delegate = self
        jsonManager.getData(with: "https://messxr.github.io/SoccerOneTeams.json")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundView?.backgroundColor = UIColor.clear
        collectionView.backgroundColor = UIColor.clear
        
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: 204, height: 314)
        layout.scrollDirection = .horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 15)
        collectionView.collectionViewLayout = layout
    }
    
    @IBAction func goButton(_ sender: UIButton) {
        teamIndex = currentPage
        performSegue(withIdentifier: "teamsToTeamInfo", sender: self)
    }
    
}

//MARK: - JSONManagerDelegate

extension TeamsViewController: JSONManagerDelegate {
    
    func didUpdateData(_ jsonManager: JSONManager, data: [[String]]) {
        DispatchQueue.main.async {
            self.teamArray = data
            if self.currentPage == 0 {
                let team = data[0]
                self.nameLabel.text = team[0]
                self.cityLabel.text = team[1]
                self.infoLabel.text = team[5]
            }
            self.collectionView.reloadData()
        }
    }
    
}

//MARK: - UICollectionViewDataSource

extension TeamsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrototypeCell", for: indexPath) as! CollectionViewCell
        cell.containerView.layer.cornerRadius = 25
        cell.containerView.layer.shadowColor = UIColor.black.cgColor
        cell.containerView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.containerView.layer.shadowOpacity = 0.2
        cell.containerView.layer.shadowRadius = 3
        cell.cellImage.image = UIImage(named: "\(teamArray[indexPath.row][2])")
        return cell
    }

}

//MARK: - UICollectionViewDelegate

extension TeamsViewController: UICollectionViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "teamsToTeamInfo" {
            let destinationVC = segue.destination as! AboutTeamViewController
            if let index = teamIndex {
                destinationVC.teamName = teamArray[index][0]
                destinationVC.teamImage = teamArray[index][2]
                destinationVC.teamAbout = teamArray[index][5]
                var counter = 0
                var array: [[String]] = [[],[]]
                for item in teamArray[index] {
                    if counter > 4 && Double(Int(counter/2)) - Double(counter)/2.0 == 0 {
                        array[0].append(item)
                    } else if counter > 5 && Double(Int(counter/2)) - Double(counter)/2.0 != 0 {
                        array[1].append(item)
                    }
                    counter += 1
                }
                destinationVC.teamSchedule = array
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        teamIndex = indexPath[1]
        performSegue(withIdentifier: "teamsToTeamInfo", sender: self)
    }

}


//MARK: - UIScrollViewDelegate


extension TeamsViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.showsHorizontalScrollIndicator = false
    }
    
}

//MARK: - SideMenu

extension TeamsViewController {
    
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

extension TeamsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}

