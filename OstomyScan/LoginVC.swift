//
//  LoginVC.swift
//  OstomyScan
//
//  Created by Lucas Cauthen on 1/15/17.
//  Copyright © 2017 OstomyTech. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    let loginProvider: LoginProvider = MockLoginProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.08, green:0.22, blue:0.44, alpha:1.0)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Hide nav bar for login view
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Show nav bar for register/forgot views
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func loginBtnWasPressed(_ sender: AnyObject) {
        if(checkLoginDetails()) {
            //Submit login to server
            //If invalid display error
            //If valid, transition to the next screen
            if let username = emailField?.text, let password = passwordField?.text {
                loginProvider.login(username: username, password: password, callback: {(success: Bool) -> (Void) in
                    if(success) {
                        let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
                        let controler = storyboard.instantiateViewController(withIdentifier: "HomeVC") as UIViewController
                        self.present(controler, animated: true, completion: nil)
                        
                    } else {
                        self.errorLabel.text = "Login failed"
                        AnimationUtility.fadeIn(self.errorLabel, duration: 0.125)
                    }
                })
            }
        }
    }
    
    func checkLoginDetails() -> Bool {
        AnimationUtility.fadeOut(errorLabel, duration: 0.05)
        if(emailField.text!.isEmpty && passwordField.text!.isEmpty) {
            errorLabel.text = "Please enter your email and a password in the fields below"
            AnimationUtility.fadeIn(errorLabel, duration: 0.125)
            AnimationUtility.jitter([emailField, passwordField])
            return false
        } else if(emailField.text!.isEmpty || !emailField.text!.contains("@")) {
            errorLabel.text =  "Please enter a valid email in the field below"
            AnimationUtility.fadeIn(errorLabel, duration: 0.125)
            AnimationUtility.jitter([emailField])
            return false
        } else if(passwordField.text!.isEmpty) {
            errorLabel.text =  "Please enter your password in the field below"
            AnimationUtility.fadeIn(errorLabel, duration: 0.125)
            AnimationUtility.jitter([passwordField])
            return false
        }
        return true
    }

}

