//
//  SignUpViewController.swift
//  Little Chime
//
//  Created by allenlinli on 9/8/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit


class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func signupWithFacebook(_ sender: AnyObject) {
        
    }
    
    
    @IBAction func signupWithGoogle(_ sender: AnyObject) {
    }
    @IBAction func signupWithEmail(_ sender: AnyObject)
    {
        showPrompt(ofTextInputWithMessage: "Email") { [weak self] (userPressedOK, email) in
            if (!userPressedOK || email!.characters.count == 0) {
                return;
            }
            
            self?.showPrompt(ofTextInputWithMessage: "Password", completion: { [weak self] (userPressedOK, password) in
                if (!userPressedOK || password!.characters.count == 0) {
                    return;
                }
                
                self?.showSpinner(with: {
                    FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { [weak self] (user, error) in
                        self?.hideSpinner(with: { [weak self] in
                            if error != nil {
                                self?.showPrompt(ofMessage: error!.localizedDescription)
                                return
                            }
                            
                            self?.dismiss(animated: true, completion: nil)
                            })
                        })
                })
                })
        }
    }
}
