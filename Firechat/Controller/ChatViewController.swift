//
//  ChatViewController.swift
//  Firechat
//
//  Created by Nikita Nesporov on 04.04.2022.
//

import UIKit
import Firebase

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Con.cellIdentifier, for: indexPath) as! MessageCell
        cell.messageLabel.text = messages[indexPath.row].body
        
        
        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
}

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    @IBOutlet weak var logOutOutlet: UIBarButtonItem!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "Hi"),
        Message(sender: "a@b.com", body: "Hey"),
        Message(sender: "1@2.com", body: "How are you?")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Con.cellNibName, bundle: nil), forCellReuseIdentifier: Con.cellIdentifier)
        
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text,
            let messageSender = Auth.auth().currentUser?.email {
            db.collection(Con.FStore.collectionName).addDocument(data: [Con.FStore.senderField: messageSender,
                                                                        Con.FStore.bodyField: messageBody]) { (error) in
                if let errors = error {
                    print(errors)
                    self.showAlert(withTitle: "There was an issue saving data to firestore ",
                                   withMessage: "\(errors.localizedDescription)")
                } else {
                    print("Successfully saved data.")
                }
            }
        }
    }
    
    
    @IBAction func logOutAction(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
 
