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
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
//                self.navigationItem.title = dictionary["username"] as? String
                
                let user = User()
                user.username = dictionary["username"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                
                self.setupNavBarWithUser(user: user)
            }
            
        })
    }

    //this sets 3 container views creating it programmatically.
    func setupNavBarWithUser(user:User){
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleToFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImagesUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        //add to subview befoer setting anchors or will crash.
        containerView.addSubview(profileImageView)
        
        //ios 9 constraints
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        
        nameLabel.text = user.username
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //specifiy x,y,width,height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }

    @objc func showChatController(){
        let chatLogController = ChatLogController()
        navigationController?.pushViewController(chatLogController, animated: true)
        
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
