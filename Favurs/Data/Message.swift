//
//  Message.swift
//  Favurs
//
//  Created by Paul on 2018-01-26.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var fromID: String?
    var text: String?
    var timestamp: NSNumber?
    var toID: String?
    var imageUrl: String?
    
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    
    
    //determine who is the current user (sender or recipeient)
    func chatPartnerId() -> String? {
        if fromID == Auth.auth().currentUser?.uid{
            return toID
        } else {
            return fromID
        }
    }
    
    //initalize method to set Message object's properties.
    init(dictionary:[String: AnyObject]){
        super.init()
        
        fromID = dictionary["fromID"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        toID = dictionary["toID"] as? String
        
        imageUrl = dictionary["imageUrl"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
    }
    
    
}
