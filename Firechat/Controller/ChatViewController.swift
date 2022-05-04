//
//  ChatViewController.swift
//  Firechat
//
//  Created by Nikita Nesporov on 04.04.2022.
//

import UIKit
import Firebase

    // MARK: - Extension Chat View Controller

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Con.cellIdentifier, for: indexPath) as! MessageCell
        cell.messageLabel.text = message.body //messages[indexPath.row].body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageView.backgroundColor = UIColor(named: Con.BrandColors.lightPurple)
            cell.messageLabel.textColor = UIColor(named: Con.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageView.backgroundColor = UIColor(named: Con.BrandColors.purple)
            cell.messageLabel.textColor = UIColor(named: Con.BrandColors.lightPurple)
        }
        
        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
}

    // MARK: - Chat View Controller

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField! 
    @IBOutlet weak var logOutOutlet: UIBarButtonItem!
    
    let dataBase = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Con.cellNibName, bundle: nil), forCellReuseIdentifier: Con.cellIdentifier)
        
        navigationItem.hidesBackButton = true
        
        messageTextfield.clearButtonMode = .whileEditing
        
        loadMesseges()
    }
    
    // MARK: - Load Messages
    
    private func loadMesseges() {
        dataBase.collection(Con.FireStore.collectionName).order(by: Con.FireStore.dateField).addSnapshotListener { (querySnapshot, error) in
            
            self.messages = []
            
            if let error = error {
                print("There was an issue retrieving data from Firestore. \(error)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[Con.FireStore.senderField] as? String,
                           let messageBody = data[Con.FireStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Action's
    
    private func sendMessage() {
        if let messageBody = messageTextfield.text,
           let messageSender = Auth.auth().currentUser?.email {
            dataBase.collection(Con.FireStore.collectionName).addDocument(data: [
                Con.FireStore.senderField: messageSender,
                Con.FireStore.bodyField: messageBody,
                Con.FireStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let errors = error {
                    print(errors)
                    self.showAlert(withTitle: "There was an issue saving data to firestore ",
                                   withMessage: "\(errors.localizedDescription)")
                } else {
                    print("Successfully saved data.")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if messageTextfield.text == "" {
            self.showAlert(withTitle: "Not now", withMessage: "Сan't send empty message :(")
        } else {
            sendMessage()
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
 
