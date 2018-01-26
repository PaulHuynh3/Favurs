//
//  NewMessageTableViewController.swift
//  Favurs
//
//  Created by Paul on 2018-01-24.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class NewMessageTableViewController: UITableViewController {

    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //fetch data from firebase
        fetchUser()
    }

    func fetchUser(){
        Database.database().reference().child("Users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
               let user = User()
               user.username = dictionary["username"] as? String
               user.email = dictionary["email"] as? String
               user.profileImageUrl = dictionary["profileImageUrl"] as? String
                
               self.users.append(user)
               
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    
        }, withCancel: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cellIdentifier", for: indexPath) as! UserCell
        let user = users[indexPath.row]
        
        cell.setUpProfile(user: user)
        
        return cell
    }

}

class UserCell: UITableViewCell {

    @IBOutlet weak var profilePictureImageview: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    func setUpProfile(user:User){
        usernameLabel.text = user.username
        emailLabel.text = user.email
        //caching images using helper function.
        profilePictureImageview.loadImagesUsingCacheWithUrlString(urlString: user.profileImageUrl!)
        profilePictureImageview.layer.cornerRadius = 25
        profilePictureImageview.layer.masksToBounds = true

    }
    
    
    
}

