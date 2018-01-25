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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cellIdentifier", for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.usernameLabel.text = user.username
        cell.emailLabel.text = user.email
        
        return cell
    }

}

class UserCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
}

