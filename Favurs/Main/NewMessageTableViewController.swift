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
        FirebaseAPI.fetchDatabaseAllUsers { (user) in
            self.users.append(user)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = self.users[indexPath.row]
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        
        navigationController?.pushViewController(chatLogController, animated: true)
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

