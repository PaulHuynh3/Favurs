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
    
    
    //determine who is the current user (sender or recipeient)
    func chatPartnerId() -> String? {
        if fromID == Auth.auth().currentUser?.uid{
            return toID
        } else {
            return fromID
        }
    }
    
    
    
}
