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

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
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
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
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
}

// [START headless_google_auth]
extension SignInViewController: GIDSignInUIDelegate
{
    /*
     // A protocol which may be implemented by consumers of |GIDSignIn| to be notified of when
     // GIDSignIn has finished dispatching the sign-in request.
     //
     // This protocol is useful for developers who implement their own "Sign In with Google" button.
     // Because there may be a brief delay between when the call to |signIn| is made, and when the
     // app switch occurs, it is best practice to have the UI react to the user's input by displaying
     // a spinner or other UI element. The |signInWillDispatch| method should be used to
     // stop or hide the spinner.
     @protocol GIDSignInUIDelegate <NSObject>
     
     @optional
     
     // The sign-in flow has finished selecting how to proceed, and the UI should no longer display
     // a spinner or other "please wait" element.
     - (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error;
     
     // If implemented, this method will be invoked when sign in needs to display a view controller.
     // The view controller should be displayed modally (via UIViewController's |presentViewController|
     // method, and not pushed unto a navigation controller's stack.
     - (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController;
     
     // If implemented, this method will be invoked when sign in needs to dismiss a view controller.
     // Typically, this should be implemented by calling |dismissViewController| on the passed
     // view controller.
     - (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController;
     */
}
// [END headless_google_auth]

// [START headless_google_auth]
extension SignInViewController: GIDSignInDelegate
{
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            showPrompt(ofMessage: error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else {
            print("Error: ! let authentication = user.authentication")
            return
        }
        
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        firebaseLogin(with: credential)
    }
    
    func firebaseLogin(with credential: FIRAuthCredential) {
        showSpinner(with: { [weak self]() in
            if let user = FIRAuth.auth()?.currentUser {
                user.link(with: credential) { (user, error) in
                    self?.hideSpinner(with: { [weak self]() in
                        if error != nil {
                            self?.showPrompt(ofMessage: error!.localizedDescription)
                            return
                        }
                    })
                }
            }
            else {
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    self?.hideSpinner(with: { [weak self]() in
                        if error != nil {
                            self?.showPrompt(ofMessage: error!.localizedDescription)
                            return
                        }
                    })
                }
            }
        })
    }
}
// [END headless_google_auth]


