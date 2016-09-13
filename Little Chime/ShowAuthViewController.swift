//
//  AuthViewController.swift
//  Little Chime
//
//  Created by allenlinli on 9/13/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

import UIKit

class ShowAuthViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        navigationController!.navigationBar.isHidden = true
    }
    
    enum SegueID: String {
        case SigninVCID
        case SignupVCID
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        guard let segueIdentifier = segue.identifier else {
            return
        }
        if (segueIdentifier == SegueID.SigninVCID.rawValue) {
            vc.title = "Sign In"
        }
        else if (segueIdentifier == SegueID.SignupVCID.rawValue) {
            vc.title = "Sign Up"
        }
    }
}
