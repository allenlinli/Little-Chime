//
//  UIViewController+Alerts.swift
//  Little Chime
//
//  Created by allenlinli on 8/30/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//
//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//


import Foundation

import UIKit


/*! @typedef AlertPromptCompletionBlock
 @brief The type of callback used to report text input prompt results.
 */
//typedef void (^AlertPromptCompletionBlock)(BOOL userPressedOK, NSString *_Nullable userInput);

/*! @class Alerts
 @brief Wrapper for @c UIAlertController and @c UIAlertView for backwards compatability with
 iOS 6+.
 */
typealias AlertPromptCompletionBlock = (_ userPressedOK: Bool, _ userInput: String?) -> Void

/*! @var kPleaseWaitAssociatedObjectKey
 @brief Key used to identify the "please wait" spinner associated object.
 */
var kPleaseWaitAssociatedObjectKey = "_UIViewControllerAlertCategory_PleaseWaitScreenAssociatedObject"

/*! @var kOK
 @brief Text for an 'OK' button.
 */
let kOK = "OK"

/*! @var kCancel
 @brief Text for an 'Cancel' button.
 */
let kCancel = "Cancel"

extension UIViewController
{
    /*! @fn showMessagePrompt:
     @brief Displays an alert with an 'OK' button and a message.
     @param message The message to display.
     */
    func showPrompt(ofMessage message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: kOK, style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    /*! @fn showTextInputPromptWithMessage:completionBlock:
     @brief Shows a prompt with a text field and 'OK'/'Cancel' buttons.
     @param message The message to display.
     @param completion A block to call when the user taps 'OK' or 'Cancel'.
     */
    func showPrompt(ofTextInputWithMessage message: String, completion:@escaping AlertPromptCompletionBlock) {
        let prompt = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: kCancel, style: .cancel, handler: { (action) in
            completion(false, nil)
        })
        let okAction = UIAlertAction(title: kOK, style: .default, handler: { (action) in
            completion(true, prompt.textFields?.first?.text)
        })
        
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(cancelAction)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil)
    }
    
    /*! @fn showSpinner
     @brief Shows the please wait spinner.
     @param completion Called after the spinner has been hidden.
     */
    func showSpinner(with completion: ( ()->Void )? )
    {
        if (objc_getAssociatedObject(self, &kPleaseWaitAssociatedObjectKey)) != nil
        {
            if completion != nil
            {
                completion?()
            }
            return
        }
        
        let pleaseWaitAlert = UIAlertController(title: nil, message: "Please Wait...\n\n\n\n", preferredStyle: .alert)
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.color = UIColor.black
        spinner.center = CGPoint(x: pleaseWaitAlert.view.bounds.size.width / 2, y: pleaseWaitAlert.view.bounds.size.height / 2)
        spinner.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        spinner.startAnimating()
        pleaseWaitAlert.view.addSubview(spinner)
        
        objc_setAssociatedObject(self, &kPleaseWaitAssociatedObjectKey, pleaseWaitAlert, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        present(pleaseWaitAlert, animated: true, completion: completion)
    }
    
    /*! @fn hideSpinner
     @brief Hides the please wait spinner.
     @param completion Called after the spinner has been hidden.
     */
    func hideSpinner(with completion: ( ()->Void )? )
    {
        let pleaseWaitAlert = objc_getAssociatedObject(self, &kPleaseWaitAssociatedObjectKey) as! UIAlertController
        pleaseWaitAlert.dismiss(animated: true, completion: completion)
        
        objc_setAssociatedObject(self, &kPleaseWaitAssociatedObjectKey, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
