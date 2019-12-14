//
//  TodayController.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 10/21/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    // MARK:- Properties
    
    fileprivate let cellId = "cellId"
    fileprivate let multipleAppCellId = "multipleAppCellId"
    static let cellSize: CGFloat = 500
    
    var appFullscreenController: AppFullscreenController!
    
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    var items = [TodayItem]()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
        
    }()
    
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    // MARK:- Initialization
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        fetchData()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = #colorLiteral(red: 0.948936522, green: 0.9490728974, blue: 0.9489067197, alpha: 1)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
    }
    
    var startingFrame: CGRect?
    
    @objc func handleAppFullscreenDismissal() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.blurVisualEffectView.alpha = 0
            self.appFullscreenController.view.transform = .identity
            
            guard let startingFrame = self.startingFrame else { return }
            
            self.anchoredConstraints?.top?.constant = startingFrame.origin.y
            self.anchoredConstraints?.leading?.constant = startingFrame.origin.x
            self.anchoredConstraints?.width?.constant = startingFrame.width
            self.anchoredConstraints?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            self.appFullscreenController.tableView.contentOffset = .zero
            
            //Replaced old transform behavior because its not working anymore on iOS 13
            //https://stackoverflow.com/questions/58199604/cgaffinetransform-translation-doesnt-work-on-tabbar-after-update-to-xcode-11
            if let frame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame = frame.offsetBy(dx: 0, dy: -100)
            }
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            //cell.closeButton.alpha = 0
            self.appFullscreenController.closeButton.alpha = 0
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.appFullscreenController.view.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
//            self.appFullscreenController.tableView.bounces = true
//            self.appFullscreenController.tableView.bouncesZoom = true
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
    
    // MARK:- Actions
    
    fileprivate func showDailyListFullscreen(_ indexPath: IndexPath) {
        let fullController = TodayMultipleAppsController(mode: .fullscreen)
        fullController.apps = self.items[indexPath.item].apps
        present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
    }
    
    fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
        let appFullscreenController = AppFullscreenController()
        appFullscreenController.todayItem = items[indexPath.row]
        appFullscreenController.dismissHandler = {
            self.handleAppFullscreenDismissal()
        }
        appFullscreenController.view.layer.cornerRadius = 16
        self.appFullscreenController = appFullscreenController
        
        // setup pan gesture
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        
        appFullscreenController.view.addGestureRecognizer(gesture)
        
    }
    
    var appFullScreenBeginOffset: CGFloat = 0
    
    @objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .began {
            appFullScreenBeginOffset = appFullscreenController.tableView.contentOffset.y
            //print(appFullScreenBeginOffset)
        }

        if appFullscreenController.tableView.contentOffset.y > 0 {
            return
        }
        
        let translationY = gesture.translation(in: appFullscreenController.view).y
        //print(translationY)
        
        if gesture.state == .changed {
            if translationY > 0 {
                let trueOffset = translationY - appFullScreenBeginOffset
                var scale = 1 - trueOffset / 1000
                
                print(trueOffset, scale)
                
                scale = min(1, scale)
                scale = max(0.5, scale)
                
                let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
                self.appFullscreenController.view.transform = transform
            }
            
        } else if gesture.state == .ended {
            if translationY > 0 {
                handleAppFullscreenDismissal()
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        // absolute coordinates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startingFrame = startingFrame
    }
    
    fileprivate func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
        let fullscreenView = appFullscreenController.view!
        
        view.addSubview(fullscreenView)
        addChild(appFullscreenController)
        
        self.collectionView.isUserInteractionEnabled = false
        
        setupStartingCellFrame(indexPath)
        
        guard let startingFrame = self.startingFrame else { return }
        
        self.anchoredConstraints = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
        
//        fullscreenView.translatesAutoresizingMaskIntoConstraints = false
//        topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
//        leadingConstraint = fullscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
//        widthConstraint = fullscreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
//        heightConstraint = fullscreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)
//
//        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({ $0?.isActive = true })
        self.view.layoutIfNeeded()
    }
    
    var anchoredConstraints: AnchoredConstraints?
    
    fileprivate func beginAnimationAppFullscreen() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffectView.alpha = 1
            
            self.anchoredConstraints?.top?.constant = 0
            self.anchoredConstraints?.leading?.constant = 0
            self.anchoredConstraints?.width?.constant = self.view.frame.width
            self.anchoredConstraints?.height?.constant = self.view.frame.height
            
//            self.topConstraint?.constant = 0
//            self.leadingConstraint?.constant = 0
//            self.widthConstraint?.constant = self.view.frame.width
//            self.heightConstraint?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded() // starts animation
            
            
            //Replaced old transform behavior because its not working anymore on iOS 13
            //https://stackoverflow.com/questions/58199604/cgaffinetransform-translation-doesnt-work-on-tabbar-after-update-to-xcode-11
            if let frame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame = frame.offsetBy(dx: 0, dy: 100)
            }
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    fileprivate func showSingleAppFullscreen(indexPath: IndexPath) {
        
        setupSingleAppFullscreenController(indexPath)
        
        setupAppFullscreenStartingPosition(indexPath)
        
        beginAnimationAppFullscreen()
    }
    
    // MARK:- Delegate Methods

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch items[indexPath.item].cellType {
        case .multiple:
            showDailyListFullscreen(indexPath)
        default:
            showSingleAppFullscreen(indexPath: indexPath)
        }
        
//        if items[indexPath.item].cellType == .multiple {
//            showDailyListFullscreen(indexPath)
//        } else {
//            showSingleAppFullscreen(indexPath: indexPath)
//        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = items[indexPath.item].cellType.rawValue
        
        // using base cell now
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        
        return cell

    }
    
    @objc fileprivate func handleMultipleAppsTap(gesture: UIGestureRecognizer) {
        let collectionView = gesture.view
        
        var superview = collectionView?.superview
        
        while superview != nil {
            if let cell = superview as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                
                let apps = self.items[indexPath.item].apps
                
                let fullController = TodayMultipleAppsController(mode: .fullscreen)
                fullController.apps = apps
                present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
                return
            }
            
            superview = superview?.superview
        }

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
