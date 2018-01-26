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

    @IBOutlet weak var favursTeamImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "StepBack")
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "StepBack")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    

    
    
    
    func defaultMessage(){
        favursTeamImage.image = #imageLiteral(resourceName: "Paul's Pic lhl")
        NameLabel.text = "Favurs Team"
        messageLabel.text = "Welcome to Favurs, you currently have no messages please connect with the Favurs community!"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! MessageTableViewCell
        
        cell.favursImageView.image = #imageLiteral(resourceName: "Paul's Pic lhl")
        cell.nameLabel.text = "Favurs Team"
        cell.messageLabel.text = "Welcome to Favurs, you currently have no messages please connect with the Favurs community!"
        
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

  

}





