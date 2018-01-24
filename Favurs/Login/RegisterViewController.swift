//
//  RegisterViewController.swift
//  Favurs
//
//  Created by Paul on 2017-12-27.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var errorCircleImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var passwordImageView: UIImageView!
  let database = Database.database().reference(fromURL:"https://favurs-fef03.firebaseio.com/")
    
    override func viewDidLoad() {
        errorCircleImageView.isHidden = true
        
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        //            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in   }) verifying email... implement later on?
        guard let username = userNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text else {return}
        
        if username == "" || email == "" || password == "" {
            if username == "" {
                usernameImageView.image = UIImage(named: "RedRectangle")
            }
            if email == "" {
                emailImageView.image = UIImage(named: "RedRectangle")
            }
            if password == "" {
                passwordImageView.image = UIImage(named:"RedRectangle")
            }
            
            errorCircleImageView.isHidden = false
            let alert = UIAlertController(title: "Required", message: "Please fill out all mandatory fields", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            DispatchQueue.main.async {
                
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "There was an error with the email entered.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                return
            }
                    guard let uid = user?.uid else {return}
                    
                    let userReference = self.database.child("Users").child(uid)
                    let values = ["username":username, "email":email, "password":password]
                    
                    userReference.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
                        if error != nil {
                            print("error with updating database", #line)
                            return
                        }
                        print("user successfully saved into firebase db")
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.transitionToUserHome()
                        
                    })
                }
        }
    }
    
}






