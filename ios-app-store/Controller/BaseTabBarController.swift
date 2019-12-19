//
//  BaseTabBarController.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 9/14/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    // MARK:- Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createNavController(viewController: TodayController(), title: "Today", imageName: "today_icon"),
            createNavController(viewController: AppsPageController(), title: "Apps", imageName: "apps"),
            createNavController(viewController: AppsSearchController(), title: "Search", imageName: "search1"),
            createNavController(viewController: MusicController(), title: "Music", imageName: "music")
        ]
        
        // can also change tabbar color and tabbar tint color
        //tabBar.tintColor = .yellow
        //tabBar.barTintColor = .gray
    }
    
    // MARK:- Actions
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        
        return navController
        
    }
}
