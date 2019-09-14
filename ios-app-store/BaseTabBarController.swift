//
//  BaseTabBarController.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 9/14/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let redViewController = UIViewController()
        redViewController.view.backgroundColor = .white
        //redViewController.tabBarItem.title = "RED"
        redViewController.navigationItem.title = "Apps"
        
        let redNavigationController = UINavigationController(rootViewController: redViewController)
        redNavigationController.tabBarItem.image = #imageLiteral(resourceName: "apps")
        redNavigationController.tabBarItem.title = "Apps"
        redNavigationController.navigationBar.prefersLargeTitles = true
        
        
        let blueViewController = UIViewController()
        blueViewController.view.backgroundColor = .white
        //blueViewController.tabBarItem.title = "BLUE"
        blueViewController.navigationItem.title = "Search"
        
        let blueNavigationController = UINavigationController(rootViewController: blueViewController)
        blueNavigationController.tabBarItem.image = UIImage(named: "search1")
        blueNavigationController.tabBarItem.title = "Search"
        blueNavigationController.navigationBar.prefersLargeTitles = true
        
        // can also change tabbar color and tabbar tint color
        //tabBar.tintColor = .yellow
        //tabBar.barTintColor = .gray
        
        viewControllers = [
        
            redNavigationController,
            blueNavigationController
        ]
    }
}
