//
//  AddMoviesViewController.swift
//  MoviesILike
//
//  Created by Andrew Mogg on 11/5/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit


class AddMoviesViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate  {

    @IBOutlet var movieNameTextField: UITextField!
    @IBOutlet var topStarsTextField: UITextField!
    @IBOutlet var movieTrailerTextField: UITextField!
    @IBOutlet var movieGenreTextField: UITextField!
    @IBOutlet var movieRatingSegmentedControl: UISegmentedControl!
    
    var movieName = ""
    var topStars = ""
    var genre = ""
    var youtubeID = ""
    
    @IBOutlet var scrollView: UIScrollView!
    
    
    // Object reference pointing to the active UITextField object
    var activeTextField: UITextField?
    
    
    // This method is invoked when the user taps the Done key on the keyboard
    @IBAction func keyboardDone(sender: UITextField) {
        
        // Once the text field is no longer the first responder, the keyboard is removed
        sender.resignFirstResponder()
    }
    
    
    /*
    ---------------------------------------
    MARK: - Handling Keyboard Notifications
    ---------------------------------------
    */
    
    // This method is called in viewDidLoad() to register self for keyboard notifications
    func registerForKeyboardNotifications() {
        
        // "An NSNotificationCenter object (or simply, notification center) provides a
        // mechanism for broadcasting information within a program." [Apple]
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self,
            selector:   "keyboardWillShow:",    // <-- Call this method upon Keyboard Will SHOW Notification
            name:       UIKeyboardWillShowNotification,
            object:     nil)
        
        notificationCenter.addObserver(self,
            selector:   "keyboardWillHide:",    //  <-- Call this method upon Keyboard Will HIDE Notification
            name:       UIKeyboardWillHideNotification,
            object:     nil)
    }
    
    
    // This method is called upon Keyboard Will SHOW Notification
    func keyboardWillShow(sender: NSNotification) {
        
        // "userInfo, the user information dictionary stores any additional
        // objects that objects receiving the notification might use." [Apple]
        let info: NSDictionary = sender.userInfo!
        
        /*
        Key     = UIKeyboardFrameBeginUserInfoKey
        Value   = an NSValue object containing a CGRect that identifies the start frame of the keyboard in screen coordinates.
        */
        let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
        
        // Obtain the size of the keyboard
        let keyboardSize: CGSize = value.CGRectValue().size
        
        // Create Edge Insets for the view.
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        
        // Set the distance that the content view is inset from the enclosing scroll view.
        scrollView.contentInset = contentInsets
        
        // Set the distance the scroll indicators are inset from the edge of the scroll view.
        scrollView.scrollIndicatorInsets = contentInsets
        
        //-----------------------------------------------------------------------------------
        // If active text field is hidden by keyboard, scroll the content up so it is visible
        //-----------------------------------------------------------------------------------
        
        // Obtain the frame size of the View
        var selfViewFrameSize: CGRect = self.view.frame
        
        // Subtract the keyboard height from the self's view height
        // and set it as the new height of the self's view
        selfViewFrameSize.size.height -= keyboardSize.height
        
        // Obtain the size of the active UITextField object
        let activeTextFieldRect: CGRect? = activeTextField!.frame
        
        // Obtain the active UITextField object's origin (x, y) coordinate
        let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
        
        
        if (!CGRectContainsPoint(selfViewFrameSize, activeTextFieldOrigin!)) {
            
            // If active UITextField object's origin is not contained within self's View Frame,
            // then scroll the content up so that the active UITextField object is visible
            scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
        }
    }
    
    // This method is called upon Keyboard Will HIDE Notification
    func keyboardWillHide(sender: NSNotification) {
        
        // Set contentInsets to top=0, left=0, bottom=0, and right=0
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        
        // Set scrollView's contentInsets to top=0, left=0, bottom=0, and right=0
        scrollView.contentInset = contentInsets
        
        // Set scrollView's scrollIndicatorInsets to top=0, left=0, bottom=0, and right=0
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    /*
    ------------------------------------
    MARK: - UITextField Delegate Methods
    ------------------------------------
    */
    
    // Assign tag numbers to the text fields in the Storyboard.
    
    // This method is called when the user taps inside a text field
    func textFieldDidBeginEditing(textField: UITextField) {
        
        activeTextField = textField
    }
    
    /*
    This method is called when the user:
    (1) selects another UI object after editing in a text field
    (2) taps Return on the keyboard
    */
    func textFieldDidEndEditing(textField: UITextField) {
        
        activeTextField = nil
        
        //Set the textField according to its tag
        if (textField.tag == 1)
        {
            movieName = textField.text!
        }
        if (textField.tag == 2)
        {
            topStars = textField.text!
        }
        if (textField.tag == 3)
        {
            genre = textField.text!
        }
        if (textField.tag == 4)
        {
            youtubeID = textField.text!
        }
        
    }
    
    // This method is called when the user taps Return on the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // Deactivate the text field and remove the keyboard
        textField.resignFirstResponder()
        
        return true
    }

    
    /*
    ---------------------------------------------
    MARK: - Register and Unregister Notifications
    ---------------------------------------------
    */
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}