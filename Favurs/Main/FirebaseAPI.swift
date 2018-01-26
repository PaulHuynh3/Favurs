//
//  FirebaseAPI.swift
//  Favurs
//
//  Created by Paul on 2018-01-26.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseAPI: NSObject {
    
    
    class func fetchDatabaseUser(uid:String, completion:@escaping (_ user:User) -> Void){
        
        Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                let user = User()
                user.username = dictionary["username"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                
                
                completion(user)
            }
        })
    }
    class func fetchDatabaseAllUsers(completion:@escaping (_ user: User) -> Void){
        
         Database.database().reference().child("Users").observe(.childAdded, with: { (snapshot) in
         
         if let dictionary = snapshot.value as? [String:AnyObject]{
         let user = User()
         user.username = dictionary["username"] as? String
         user.email = dictionary["email"] as? String
         user.profileImageUrl = dictionary["profileImageUrl"] as? String
         
            completion(user)
         }
         
         }, withCancel: nil)
    }

    
}
