//
//  RegisterViewController.swift
//  Firechat
//
//  Created by Nikita Nesporov on 04.04.2022.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let errors = error {
                    print(errors)
                    self.showAlert(withTitle: "Error", withMessage: "\(errors.localizedDescription)")
                } else {
                    self.performSegue(withIdentifier: Con.registerSegue, sender: self)
                }
            }
        }
    }
}
  
