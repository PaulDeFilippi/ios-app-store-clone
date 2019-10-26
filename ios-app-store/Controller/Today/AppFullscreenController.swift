//
//  AppFullscreenController.swift
//  ios-app-store
//
//  Created by Paul Defilippi on 10/23/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import UIKit

class AppFullscreenController: UITableViewController {
    
    var dismissHandler: (() ->())?
    
    // MARK:- Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

    }
    
    // MARK:- Actions
    
    @objc fileprivate func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
    
    // MARK:- Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            let headerCell = AppFullscreenHeaderCell()
            headerCell.closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            return headerCell
        }
        
        let cell = AppFullscreenDescriptionCell()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
           return 450
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
        
    }

}

