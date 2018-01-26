//
//  MessageTableViewCell.swift
//  Favurs
//
//  Created by Paul on 2018-01-17.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favursImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setMessages(message:Message){
        nameLabel.text = message.toID
        messageLabel.text = message.text
        
    }

}
