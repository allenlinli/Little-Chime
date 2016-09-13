//
//  AuthViewController.swift
//  Little Chime
//
//  Created by allenlinli on 9/13/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        navigationController!.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController!.navigationBar.isHidden = false
    }
}
