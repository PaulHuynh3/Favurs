//
//  ChatViewController.swift
//  Favurs
//
//  Created by Paul on 2018-01-23.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation
import UIKit

class ChatLogController: UICollectionViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = "Chat Log Controller"
        
        setupInputComponents()
    }
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //set constraints
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    
}

