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
            print("FBLogin cancelled")
            return
        }
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: result.token.tokenString)
        self.firebaseLogin(with: credential)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()!.signOut()
    }
}
