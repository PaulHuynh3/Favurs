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
    
    var messages = [Message]()
    //stores the userid of receipient(group messages)
    var messagesDictionary = [String: Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "StepBack")
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "StepBack")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        fetchUserAndSetupNavBarTitle()
        
        //moving this into setupnavbarwithuser.... (check if it will work with my code tmrw)
        //should be able to see messages instantly and clear the old ones.
//        observeUserMessages()
        //reveal delete button
        tableView.allowsSelectionDuringEditing = true
    }
     //reveal delete button
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //performs deletion here
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let message = self.messages[indexPath.row]
        
        if let chatPartnerId = message.chatPartnerId() {
            Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (error, ref) in
                
                if error != nil {
                    print("Failed to delete message:", error!)
                    return
                }
                
                self.messagesDictionary.removeValue(forKey: chatPartnerId)
                self.attemptReloadOfTable()
                
            })
        }
    }
    
    func observeUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {return }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        //.childAdded returns a specific element like messages associated with the key
        ref.observe(.childAdded, with: { (snapshot) in
            //snapshot gives child node of uid which is the node under..
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                
                self.fetchMessageWithMessageId(messageId: messageId)
                
            }, withCancel: nil)
                
        }, withCancel: nil)
        
        //check to see if data was remove from database.. therefore the deleted message wont show on the application anymore.
        ref.observe(.childRemoved, with: { (snapshot) in
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadOfTable()
            
        }, withCancel: nil)
    }
    
    private func fetchMessageWithMessageId(messageId: String) {
        //within the tree of the database messages... snapshot.key takes the user-messages of all messages relating to the currently logged in user.
        let messageReference = Database.database().reference().child("messages").child(messageId)
        
        //.value returns all the value associated with the child references
        messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let message = Message(dictionary: dictionary)
                
                //This dictionary stores all the people who sent the messages by their ID therefore you can group messages together.
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                    
                }
                self.attemptReloadOfTable()
                
            }
            
        }, withCancel: nil)
    }
    
    private func attemptReloadOfTable() {
        //the timer makes it so the execution can be scheduled to execute so let the cell almost finish loading before we reload the cells.
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval:0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    @objc func handleReloadTable() {
        //set the messages arry equal to the messagesDictionary which contains all the messages.. This will reconstruct it right before the table reloads.
        self.messages = Array(self.messagesDictionary.values)
        
        //does a comparison to see which timestamp is greater and put that message on top.
        self.messages.sort(by: { (message1, message2) -> Bool in
            return message1.timestamp!.int32Value > message2.timestamp!.int32Value
        })
        
        DispatchQueue.main.async {
            //everytime the observemessage is called reload tableview is called.. so we need to make it only call it once.
            self.tableView.reloadData()
        }
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
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        
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
        
//        titleView.addTarget(self, action: #selector(showChatController), for: .touchUpInside)
        
    }
    
    func showChatController(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! MessageTableViewCell
        
        let message = messages[indexPath.row]
        
        cell.message = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        //function to determine who is the current user(recipient/sender)
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            
            let user = User()
            user.id = chatPartnerId
            user.username = dictionary["username"] as? String
            user.email = dictionary["email"] as? String
            user.profileImageUrl = dictionary["profileImageUrl"] as? String
            
            self.showChatController(user)
            
        }, withCancel: nil)
        
    }

  
//    func defaultMessage{
//        cell.favursImageView.image = #imageLiteral(resourceName: "Paul's Pic lhl")
//        cell.nameLabel.text = "Favurs Team"
//        cell.messageLabel.text = "Welcome to Favurs, you currently have no messages please connect with the Favurs community!"
//
//    }
    

}





