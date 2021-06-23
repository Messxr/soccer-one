//
//  ArticlesViewController.swift
//  Soccer One
//
//  Created by Daniil Marusenko on 04.12.2020.
//

import UIKit
import UPCarouselFlowLayout

class NewsListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var jsonManager = JSONManager()
    var articleArray: [[String]] = []
    var articleIndex: Int?
    let transiton = SlideInTransition()
    var topView: UIView?
    
    fileprivate var currentPage: Int = 0 {
        didSet {
            jsonManager.getData(with: "https://messxr.github.io/SoccerOneArticles.json")
            while articleArray == [] { return }
            let team = articleArray[currentPage]
            nameLabel.text = team[1]
            infoLabel.text = team[3]
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
        jsonManager.getData(with: "https://messxr.github.io/SoccerOneArticles.json")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundView?.backgroundColor = UIColor.clear
        collectionView.backgroundColor = UIColor.clear
        
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: 284, height: 436)
        layout.scrollDirection = .horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 15)
        collectionView.collectionViewLayout = layout
    }
    
    @IBAction func goButton(_ sender: UIButton) {
        articleIndex = currentPage
        performSegue(withIdentifier: "articlesToArticleInfo", sender: self)
    }
    

}

//MARK: - JSONManagerDelegate

extension NewsListViewController: JSONManagerDelegate {
    
    func didUpdateData(_ jsonManager: JSONManager, data: [[String]]) {
        DispatchQueue.main.async {
            self.articleArray = data
            if self.currentPage == 0 {
                let team = data[0]
                self.nameLabel.text = team[1]
                self.infoLabel.text = team[3]
            }
            self.collectionView.reloadData()
        }
    }
    
}

//MARK: - UICollectionViewDataSource

extension NewsListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articleArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrototypeCell", for: indexPath) as! CollectionViewCell
        cell.containerView.layer.cornerRadius = 25
        cell.containerView.layer.shadowColor = UIColor.black.cgColor
        cell.containerView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.containerView.layer.shadowOpacity = 0.2
        cell.containerView.layer.shadowRadius = 3
        cell.cellImage.layer.cornerRadius = 25
        cell.miniContainer.layer.cornerRadius = 25
        cell.miniContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        cell.miniContainer.alpha = 0.8
        cell.setImage(articleArray[indexPath.row][0])
        cell.cellTitle.text = articleArray[indexPath.row][2]
        return cell
    }

}

//MARK: - UICollectionViewDelegate

extension NewsListViewController: UICollectionViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "articlesToArticleInfo" {
            let destinationVC = segue.destination as! AboutNewsViewController
            if let index = articleIndex {
                destinationVC.articleImage = articleArray[index][0]
                destinationVC.articleName = articleArray[index][1]
                destinationVC.articleDate = articleArray[index][2]
                destinationVC.articleInfo = articleArray[index][3]
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        articleIndex = indexPath[1]
        performSegue(withIdentifier: "articlesToArticleInfo", sender: self)
    }
        
}


//MARK: - UIScrollViewDelegate

extension NewsListViewController: UIScrollViewDelegate {
    
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

extension NewsListViewController {
    
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

extension NewsListViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}

