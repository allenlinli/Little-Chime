//
//  AuthViewController+GoogleSignin.swift
//  Little Chime
//
//  Created by allenlinli on 9/15/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

import Foundation
import GoogleSignIn
import Firebase

extension AuthViewController: GIDSignInUIDelegate
{
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        if let error = error {
            showPrompt(ofMessage: error.localizedDescription)
            return
        }
    }
}

extension AuthViewController: GIDSignInDelegate
{
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            showPrompt(ofMessage: error.localizedDescription)
            return
        }
    }
    
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
}
