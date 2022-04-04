//
//  ViewController.swift
//  Firechat
//
//  Created by Nikita Nesporov on 04.04.2022.
//
 
import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var registerOutlet: UIButton!
    @IBOutlet weak var loginOutlet: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = Con.appName
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
    
    func setupViews() {
        let buttons = [registerOutlet, loginOutlet]
        for button in buttons {
            button?.layer.cornerRadius = 12
            button?.clipsToBounds = true
        }
    }
}
