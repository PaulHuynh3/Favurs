//
//  LoginViewController.swift
//  Favurs
//
//  Created by Paul on 2017-12-21.
//  Copyright © 2017 Paul. All rights reserved.

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Automatically sign in fb token exist.
//        if (FBSDKAccessToken.current() != nil) {
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            appDelegate?.transitionToUserHome()
//        }
        
        //configure facebok login button.
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.readPermissions = ["public_profile", "email"]
        loginButton.center = view.center
        loginButton.delegate = self
    }
    
    //MARK: Facebook delegate methods.
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("LOGGED OUT OF FACEBOOK")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Error loging in")
            return
        }
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.transitionToUserHome()
        print("SUCCESSFULLY LOGGED INTO FACEBOOK")
    }
    
    //MARK: sign in with email and password.
    @IBAction func signInButtonTapped(_ sender: Any) {
        //check text is not nil, check text matches data from database.
        //provide more checks on the textfields.
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user,error) in
            
            if let user = user {
                //set user to nsdefault or as firebase current user to track the current user
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.transitionToUserHome()
                
            } else {
                
                let alert = UIAlertController(title: "Login Error", message: "Username or password is incorrect", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
           }
            
        
        }
    
     }
    
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "signUpIdentifier", sender: self)
    }
}

class ForgotPasswordViewController: UIViewController {
   var auth = Auth.auth()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorCircleImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        errorCircleImageView.isHidden = true
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text else{return}
        if email == "" {
            emailImageView.image = UIImage(named:"RedRectangle")
            errorCircleImageView.isHidden = false
            return
        }
        
         self.activityIndicator.startAnimating()
        
        auth.sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                
                let alert = UIAlertController(title: "Reset password error", message: "The email you entered is not found.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                self.performSegue(withIdentifier: "resetPasswordIdentifier", sender: self)
            }
            
        }
        activityIndicator.stopAnimating()

    }
    
    
}

class EmailSentViewController: UIViewController {
    
    
    @IBAction func soundsGoodButtonPressed(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    
}

