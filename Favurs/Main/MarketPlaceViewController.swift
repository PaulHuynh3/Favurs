//
//  MarketPlaceViewController.swift
//  Favurs
//
//  Created by Paul on 2018-01-24.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MarketPlaceViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
     
        //need to adjust this so fbsdk login works as well.
        checkIfUserIsLoggedIn()
    }
        
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            performSelector(inBackground: #selector(handleLogout), with: nil)
            handleLogout()
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("Users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.navigationItem.title = dictionary["username"] as? String
                }
                
            })
        }
    }
    

    
    @objc func handleLogout(){
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        DispatchQueue.main.async {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.transitionToLogin()
        }
    }
    
    
}
