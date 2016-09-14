//
//  SignInViewController.swift
//  Little Chime
//
//  Created by allenlinli on 8/30/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase
import FBSDKLoginKit

class AuthViewController: UIViewController {

    enum AuthType: String
    {
        case signin
        case signup
    }
    
    var authType: AuthType!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retreivePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (authType == AuthType.signin) {
            title = "Sign In"
            signinButton.isHidden = false
            signupButton.isHidden = true
            retreivePasswordButton.isHidden = false
        }
        else {
            title = "Sign Up"
            signinButton.isHidden = true
            signupButton.isHidden = false
            retreivePasswordButton.isHidden = true
        }
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        navigationController!.navigationBar.isHidden = false
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("singleTapped:"))
        singleTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    func singleTapped(_ sender: AnyObject) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // MARK: signin
    @IBAction func signInWithEmail(_ sender: AnyObject) {
        guard let email = emailTextField.text else {
            showPrompt(ofMessage: "Please Fill in Email.")
            return
        }
        guard let password = passwordTextField.text else {
            showPrompt(ofMessage: "Please Fill in password.")
            return
        }
        
        showSpinner { 
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
                self?.hideSpinner(with: { 
                    if error != nil {
                        self?.showPrompt(ofMessage: error!.localizedDescription)
                        return
                    }
                    
                    //post signin succeeded notification
                    self?.dismiss(animated: true, completion: nil)
                })
            })
        }
    }
    
    @IBAction func signInWithGoogle(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func signInWithFacebook(_ sender: AnyObject) {
        FBSDKLoginManager().logIn(withReadPermissions: [ "public_profile", "email" ], from: self, handler: { [weak self] (result, error) in
            if error != nil {
                self?.showPrompt(ofMessage: error!.localizedDescription)
                return
            }
            if (result?.isCancelled)! {
                print("FBLogin cancelled")
                return
            }
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            self?.firebaseLogin(with: credential)
        })
    }
    
    // Mark: Signup
    @IBAction func signupWithGoogle(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func signupWithEmail(_ sender: AnyObject)
    {
        guard let email = emailTextField.text else {
            showPrompt(ofMessage: "Please Fill in Email.")
            return
        }
        guard let password = passwordTextField.text else {
            showPrompt(ofMessage: "Please Fill in password.")
            return
        }
        
        // TODO: examine email and password
        showSpinner(with: {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { [weak self] (user, error) in
                self?.hideSpinner(with: { [weak self] in
                    if error != nil {
                        self?.showPrompt(ofMessage: error!.localizedDescription)
                        return
                    }
                    
                    self?.showPrompt(ofMessage: "Account Created!")
        
                    _ = self?.navigationController?.popViewController(animated: true)
                })
            })
        })
    }
    
    // MARK: retreivePassword
    @IBAction func retreivePasswordButtonPressed(_ sender: AnyObject) {
        showPrompt(ofTextInputWithMessage: "Email:") { [weak self] (userPressedOK, userInput)  in
            if let userInput = userInput {
                self?.showSpinner(with: { [weak self] in
                    FIRAuth.auth()?.sendPasswordReset(withEmail: userInput) { [weak self] (error) in
                        if error != nil {
                            self?.showPrompt(ofMessage: error!.localizedDescription)
                            return
                        }
                        
                        self?.hideSpinner(with: { [weak self] in
                            if error != nil {
                                self?.showPrompt(ofMessage: error!.localizedDescription)
                                return
                            }
                            
                            self?.showPrompt(ofMessage: "Reset password email sent")
                        })
                    }
                })
            }
        }
    }
}

extension AuthViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
            return true
        }
        else if textField == passwordTextField {
            textField.resignFirstResponder()
            return true
        }
        return true
    }
}

extension AuthViewController
{
    func firebaseLogin(with credential: FIRAuthCredential) {
        showSpinner(with: { [weak self]() in
            if let user = FIRAuth.auth()?.currentUser {
                // upload credential and link with user
                user.link(with: credential) { (user, error) in
                    self?.hideSpinner(with: { [weak self]() in
                        if error != nil {
                            self?.showPrompt(ofMessage: error!.localizedDescription)
                            return
                        }
                        
                        self?.dismiss(animated: true, completion: {
                            
                        })
                    })
                }
            }
            else {
                // just sign in
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    self?.hideSpinner(with: { [weak self]() in
                        if error != nil {
                            self?.showPrompt(ofMessage: error!.localizedDescription)
                            return
                        }
                        
                        self?.dismiss(animated: true, completion: {
                            
                        })
                    })
                }
            }
        })
    }
}




