//
//  MainViewController.swift
//  Little Chime
//
//  Created by allenlinli on 8/30/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: UIViewController {

    var authStateHandle: FIRAuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        // MARK: Auth
        //If auth is not established, then pop up SignInVC
        authStateHandle = FIRAuth.auth()?.addStateDidChangeListener{ [weak self](auth, user) in
            if user == nil
            {
                self?.performSegue(withIdentifier: "ShowSignInVCID", sender: self)
                return
            }
            
            if let strongSelf = self
            {
                _ = strongSelf.navigationController?.popToViewController(strongSelf, animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FIRAuth.auth()?.removeStateDidChangeListener(authStateHandle!)
    }
}
