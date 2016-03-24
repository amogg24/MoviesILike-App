//
//  MovieSearchViewController.swift
//  MoviesILike
//
//  Created by Andrew Mogg on 11/5/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController, UITextFieldDelegate {

    // Object reference pointing to the active UITextField object
    @IBOutlet var activeTextField: UITextField?
    var enteredSearch: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    ------------------------
    MARK: - IBAction Methods
    ------------------------
    */
    @IBAction func keyboardDone(sender: UITextField) {
        
        // Deactivate the Address Text Field object and remove the Keyboard
        sender.resignFirstResponder()
        let search = (activeTextField?.text!)!
       
        enteredSearch = search.stringByReplacingOccurrencesOfString(" ", withString: "+", options: [], range: nil)
        performSegueWithIdentifier("SearchMovie", sender: self)
    }
    
    @IBAction func backgroundTouch(sender: UIControl) {
        
        // Deactivate the Address Text Field object and remove the Keyboard
        activeTextField!.resignFirstResponder()
    }
    
    /*
    -------------------------
    MARK: - Prepare For Segue
    -------------------------
    */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "SearchMovie" {
            
            // Obtain the object reference of the destination view controller
            let moviesTableViewController: MoviesTableViewController = segue.destinationViewController as!MoviesTableViewController
            
            // Under the Delegation Design Pattern, set the addCityViewController's delegate to be self
            moviesTableViewController.movieNameToSearch = enteredSearch
            activeTextField?.text = ""
            
        }
    }
}
