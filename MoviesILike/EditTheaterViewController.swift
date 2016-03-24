//
//  EditTheaterViewController.swift
//  MoviesILike
//
//  Created by Andrew Mogg on 11/5/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit

class EditTheaterViewController: UIViewController {
    let applicationDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    //var delegate: EditTheaterViewControllerProtocol?
    
    // Obtain the object reference of the movie name text field
    @IBOutlet var theaterNameTextField: UITextField!
    
    // Obtain the object reference of the top stars text field
    @IBOutlet var theaterAddressTextField: UITextField!
    
    // Object reference pointing to the active UITextField object
    var activeTextField: UITextField?
    var dataObjectPassed: [String] = ["",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theaterNameTextField.text = dataObjectPassed[0]
        theaterAddressTextField.text = dataObjectPassed[1]
    }
    
    // This method is invoked when the user taps the Done key on the keyboard
    @IBAction func keyboardDone(sender: UITextField) {
        
        // Once the text field is no longer the first responder, the keyboard is removed
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTouch(sender: UIControl) {
        
        if(theaterNameTextField.isFirstResponder())
        {
            theaterNameTextField.resignFirstResponder()
        }
        else
        {
            theaterAddressTextField.resignFirstResponder()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "EditTheater-Save" {
            if (theaterAddressTextField.text == "" || theaterAddressTextField.text == "") {
                let alertController = UIAlertController(title: "Must Enter all Fields",
                    message: "All text fields must have input",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                // Create a UIAlertAction object and add it to the alert controller
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                // Present the alert controller by calling the presentViewController method
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }


}
