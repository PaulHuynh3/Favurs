//
//  MessageTableViewCell.swift
//  Favurs
//
//  Created by Paul on 2018-01-17.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class MessageTableViewCell: UITableViewCell {
    
    var message: Message? {
        didSet{
            //Populate the messagetablevc cellforrow. (maybe turn this into a function?
            if let toID = message?.toID {
                let ref = Database.database().reference().child("Users").child(toID)
                
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        
                      
                        self.nameLabel.text = dictionary["username"] as? String
                        
                        if let profileImageUrl = dictionary["profileImageUrl"] as? String{
                            self.favursImageView.loadImagesUsingCacheWithUrlString(urlString: profileImageUrl)
                        }
                    }
                }, withCancel: nil)
            }
              messageLabel.text = message?.text
            
            if let seconds = message?.timeStamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                //specific dateformat encryption found online...
                dateFormatter.dateFormat = "hh:mm:ss a"
                timestampLabel.text = dateFormatter.string(from: timestampDate)
                
            }
        }
    }
    
    @IBOutlet weak var favursImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setMessages(message:Message){
        nameLabel.text = message.toID
        messageLabel.text = message.text
        
    }

}
