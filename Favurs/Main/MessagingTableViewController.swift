//
//  MessagingTableViewController.swift
//  Favurs
//
//  Created by Paul on 2018-01-17.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class MessagingTableViewController: UITableViewController {
    
    var users =  [User]()
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "StepBack")
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "StepBack")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        fetchUserAndSetupNavBarTitle()
        
        observeMessages()
    
    }
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        FirebaseAPI.fetchDatabaseUser(uid: uid, completion: { (user) in
            self.setupNavBarWithUser(user)
        })
    }
    
    //this sets 3 container views creating it programmatically.
    func setupNavBarWithUser(_ user: User) {
        let titleView = UIButton()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //        titleView.backgroundColor = UIColor.redColor()
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImagesUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.username
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //need x,y,width,height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        
        titleView.addTarget(self, action: #selector(showChatController), for: .touchUpInside)
        
    }
    
    @objc func showChatController() {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func observeMessages(){
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
      
            if let dictionary = snapshot.value as? [String:AnyObject]{
        let message = Message()
        message.toID = dictionary["toID"] as? String
        message.fromID = dictionary["fromID"] as? String
        message.timeStamp = dictionary["timeStamp"] as? Int
        message.text = dictionary["text"] as? String

        self.messages.append(message)

           DispatchQueue.main.async {
            self.tableView.reloadData()
            }
         }
            
        }, withCancel: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! MessageTableViewCell
        
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.text

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "showMessage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMessage"{
            
        }
        
    }

  
//    func defaultMessage{
//        cell.favursImageView.image = #imageLiteral(resourceName: "Paul's Pic lhl")
//        cell.nameLabel.text = "Favurs Team"
//        cell.messageLabel.text = "Welcome to Favurs, you currently have no messages please connect with the Favurs community!"
//
//    }
    

}





