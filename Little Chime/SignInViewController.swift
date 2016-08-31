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

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signInWithEmail(_ sender: AnyObject) {
    }
    
    @IBAction func signInWithGoogle(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func signInWithFacebook(_ sender: AnyObject) {
        /*
        let loginManager = FBSDKLoginManager()
        loginManager.logInWithReadPermissions(["email"], fromViewController: self, handler: { (result, error) in
            if let error = error {
                self.showMessagePrompt(error.localizedDescription)
            } else if(result.isCancelled) {
                print("FBLogin cancelled")
            } else {
                // [START headless_facebook_auth]
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                // [END headless_facebook_auth]
                self.firebaseLogin(credential)
            }
        })
 */
    }
}

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

extension SignInViewController: GIDSignInDelegate
{
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard let authentication = user.authentication else {
            print("Error: ! let authentication = user.authentication")
            return
        }
        
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication.idToken)!,
                                                          accessToken: (authentication.accessToken)!)
        
        // [START_EXCLUDE]
        firebaseLogin(with: credential)
        // [END_EXCLUDE]
    }

    /*
     // A protocol implemented by the delegate of |GIDSignIn| to receive a refresh token or an error.
     @protocol GIDSignInDelegate <NSObject>
     
     // The sign-in flow has finished and was successful if |error| is |nil|.
     - (void)signIn:(GIDSignIn *)signIn
     didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error;
     
     @optional
     
     // Finished disconnecting |user| from the app successfully if |error| is |nil|.
     - (void)signIn:(GIDSignIn *)signIn
     didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error;
     
     @end
     */
    func firebaseLogin(with credential: FIRAuthCredential) {
        showSpinner(with: { [weak self]() in
            if let user = FIRAuth.auth()?.currentUser {
                // [START link_credential]
                user.link(with: credential) { (user, error) in
                    // [START_EXCLUDE]
                    self?.hideSpinner(with: { [weak self]() in
                        if let error = error {
                            self?.showPrompt(ofMessage: error.localizedDescription)
                            return
                        }
                    })
                    // [END_EXCLUDE]
                }
                // [END link_credential]
            } else {
                // [START signin_credential]
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    // [START_EXCLUDE]
                    self?.hideSpinner(with: { [weak self]() in
                        if let error = error {
                            self?.showPrompt(ofMessage: error.localizedDescription)
                            return
                        }
                    })
                    // [END_EXCLUDE]
                }
                // [END signin_credential]
            }
        })
    }
}



