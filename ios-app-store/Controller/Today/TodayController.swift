//
//  TodayController.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 10/21/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    // MARK:- Properties
    
    fileprivate let cellId = "cellId"
    fileprivate let multipleAppCellId = "multipleAppCellId"
    static let cellSize: CGFloat = 500
    
    var appFullscreenController: AppFullscreenController!
    
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
//    let items = [

//        TodayItem.init(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everytthing.", backgroundColor: #colorLiteral(red: 0.9833490252, green: 0.9629909396, blue: 0.7271831632, alpha: 1), cellType: .single),
//        TodayItem.init(category: "TOP GROSSING", title: "Top grossing Apps", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple),
//    ]
    
    var items = [TodayItem]()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
        
    }()
    
    // MARK:- Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        fetchData()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = #colorLiteral(red: 0.948936522, green: 0.9490728974, blue: 0.9489067197, alpha: 1)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
    }
    
    var startingFrame: CGRect?
    
    @objc func handleRemoveRedView() {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.appFullscreenController.tableView.contentOffset = .zero
            
            guard let startingFrame = self.startingFrame else { return }
            
            self.topConstraint?.constant = startingFrame.origin.y
            self.leadingConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.transform = .identity
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.appFullscreenController.view.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    fileprivate func fetchData() {
        // dispatch group
        
        let dispatchGroup = DispatchGroup()
        
        var topGrossingGroup: AppGroup?
        var gamesGroup: AppGroup?
        
        dispatchGroup.enter()
        APIService.shared.fetchTopGrossing { (appGroup, err) in
            // TODO:- Check errors
            
            topGrossingGroup = appGroup
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        APIService.shared.fetchGames { (appGroup, err) in
            
            gamesGroup = appGroup
            
            dispatchGroup.leave()
        }
        
        // treat this as completion block
        dispatchGroup.notify(queue: .main) {
            print("Finished Fetching")
            self.activityIndicatorView.stopAnimating()
            
            self.items = [
                
                TodayItem.init(category: "Daily List", title: topGrossingGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, apps: topGrossingGroup?.feed.results ?? [], cellType: .multiple),
                TodayItem.init(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everytthing.", backgroundColor: #colorLiteral(red: 0.9833490252, green: 0.9629909396, blue: 0.7271831632, alpha: 1), apps: [], cellType: .single),
                TodayItem.init(category: "Daily List", title: gamesGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, apps: gamesGroup?.feed.results ?? [], cellType: .multiple),
                TodayItem.init(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, apps: [], cellType: .single)
                
            ]
            
            self.collectionView.reloadData()
            
        }
    
    }
    
    // MARK:- Delegate Methods
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if items[indexPath.item].cellType == .multiple {
            let fullController = TodayMultipleAppsController(mode: .fullscreen)
//            fullController.view.backgroundColor = .red
            fullController.results = self.items[indexPath.item].apps
            present(fullController, animated: true)
            return
        }
        
        let appFullscreenController = AppFullscreenController()
        appFullscreenController.todayItem = items[indexPath.row]
        appFullscreenController.dismissHandler = {
            self.handleRemoveRedView()
        }
        
        let fullscreenView = appFullscreenController.view!
        
        view.addSubview(fullscreenView)
        addChild(appFullscreenController)
        
        self.appFullscreenController = appFullscreenController
        
        self.collectionView.isUserInteractionEnabled = false
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }

        // absolute coordinates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startingFrame = startingFrame

        fullscreenView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = fullscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = fullscreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = fullscreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)
        
        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({ $0?.isActive = true })
        self.view.layoutIfNeeded()
        
        fullscreenView.layer.cornerRadius = 16
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {

            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded() // starts animation
            
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = items[indexPath.item].cellType.rawValue
        
        // using base cell now
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        
//        if let cell = cell as? TodayCell {
//            cell.todayItem = items[indexPath.item]
//
//        } else if let cell = cell as? TodayMultipleAppCell {
//            cell.todayItem = items[indexPath.item]
//        }
        
        return cell
        
        // multiple app cell
        // hard coded check
//        if indexPath.item == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: multipleAppCellId, for: indexPath) as! TodayMultipleAppCell
//            cell.todayItem = items[indexPath.item]
//            return cell
//        }
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCell
//        cell.todayItem = items[indexPath.item]
//        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
    
}
