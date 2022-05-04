//
//  LoginViewController.swift
//  Firechat
//
//  Created by Nikita Nesporov on 04.04.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tryLogin() 
    }
     
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in 
                if let errors = error {
                    print(errors)
                    self.showAlert(withTitle: "Error", withMessage: "\(errors.localizedDescription)")
                } else {
                    self.performSegue(withIdentifier: Con.loginSegue, sender: self)
                }
            }
        }
    }
    
    private func tryLogin() {
        emailTextfield.text = "1@2.com"
        passwordTextfield.text = "123456"
    }
}
