//
//  AuthViewController+FBSignin.swift
//  Little Chime
//
//  Created by allenlinli on 9/15/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

extension AuthViewController: FBSDKLoginButtonDelegate
{
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            showPrompt(ofMessage: error.localizedDescription)
            return
        }
        else if result.isCancelled {
            return
        }
        
        //let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: result.token.tokenString)
        FIRAuth.auth()?.signIn(with: credential) { [weak self] (user, error) in
            if let error = error {
                self?.showPrompt(ofMessage: error.localizedDescription)
                return
            }
            
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()!.signOut()
    }
}
