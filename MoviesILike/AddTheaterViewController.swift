//
//  AddTheaterViewController.swift
//  MoviesILike
//
//  Created by Andrew Mogg on 11/5/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit

class AddTheaterViewController: UIViewController {

    @IBOutlet var movieTheaterNameToAdd: UITextField!
    @IBOutlet var movieTheaterAddressToAdd: UITextField!
    var flag: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()        // Do any additional setup after loading the view.
    }

    /*
    ---------------------------------
    MARK: - Keyboard Handling Methods
    ---------------------------------
    */
    
    // This method is invoked when the user taps the Done key on the keyboard
    @IBAction func keyboardDone(sender: UITextField) {
        
        // Once the text field is no longer the first responder, the keyboard is removed
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTouch(sender: UIControl) {
        
        if(movieTheaterNameToAdd.isFirstResponder())
        {
            movieTheaterNameToAdd.resignFirstResponder()
        }
        else
        {
            movieTheaterAddressToAdd.resignFirstResponder()
        }
    }
}
