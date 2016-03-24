//
//  MovieGenresViewController.swift
//  MoviesILike
//
//  Created by Andrew Mogg on 11/5/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit

class MovieGenresViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var leftArrowWhite: UIImageView!
    @IBOutlet var rightArrowWhite: UIImageView!
    @IBOutlet var scrollMenu: UIScrollView!
    
    var dataObjectToPass: [String] = ["", ""]
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // Create and initialize the array to store auto manufacturer names
    var genres = [String]()
    
    // Other properties (instance variables) and their initializations
    let kScrollMenuHeight: CGFloat = 30.0
    var selectedGenre = ""
    var previousButton = UIButton(frame: CGRectMake(0, 0, 0, 0))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        allKeys returns a new array containing the dictionary’s keys as of type AnyObject.
        Therefore, typecast the AnyObject type keys to be of type String.
        The keys in the array are *unordered*; therefore, they need to be sorted.
        */
        genres = applicationDelegate.dict_GenreData.allKeys as! [String]
        
        // Sort the country names within itself in alphabetical order
        genres.sortInPlace { $0 < $1 }

        /**********************
        * Set Background Colors
        **********************/
        
        self.view.backgroundColor = UIColor.whiteColor()
        leftArrowWhite.backgroundColor = UIColor.blackColor()
        rightArrowWhite.backgroundColor = UIColor.blackColor()
        scrollMenu.backgroundColor = UIColor.blackColor()
        
        /***********************************************************************
         * Instantiate and setup the buttons for the horizontally scrollable menu
         ***********************************************************************/
         
         // Instantiate a mutable array to hold the menu buttons to be created
        var listOfMenuButtons = [UIButton]()
        
        for var i = 0; i < genres.count; i++ {
            
            // Instantiate a button to be placed within the horizontally scrollable menu
            let scrollMenuButton = UIButton(type: UIButtonType.Custom)
            
            // Obtain the title (i.e., auto manufacturer name) to be displayed on the button
            let buttonTitle = genres[i]
            
            // The button width and height in points will depend on its font style and size
            let buttonTitleFont = UIFont(name: "Helvetica-Bold", size: 17.0)
            
            // Set the font of the button title label text
            scrollMenuButton.titleLabel?.font = buttonTitleFont
            
            // Compute the size of the button title in points
            let buttonTitleSize: CGSize = (buttonTitle as NSString).sizeWithAttributes([NSFontAttributeName:buttonTitleFont!])
            
            // Add 20 points to the width to leave 10 points on each side.
            // Set the button frame with width=buttonWidth height=kScrollMenuHeight points with origin at (x, y) = (0, 0)
            scrollMenuButton.frame = CGRectMake(0.0, 0.0, buttonTitleSize.width + 20.0, kScrollMenuHeight)
            
            // Set the background color of the button to black
            scrollMenuButton.backgroundColor = UIColor.blackColor()
            
            // Set the button title to the automobile manufacturer's name
            scrollMenuButton.setTitle(buttonTitle, forState: UIControlState.Normal)
            
            // Set the button title color to white
            scrollMenuButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            // Set the button title color to red when the button is selected
            scrollMenuButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
            
            // Set the button to invoke the buttonPressed: method when the user taps it
            scrollMenuButton.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
            
            // Add the constructed button to the list of buttons
            listOfMenuButtons.append(scrollMenuButton)
        }
        
        /*********************************************************************************************
         * Compute the sumOfButtonWidths = sum of the widths of all buttons to be displayed in the menu
         *********************************************************************************************/
        
        var sumOfButtonWidths: CGFloat = 0.0
        
        for var j = 0; j < listOfMenuButtons.count; j++ {
            
            // Obtain the obj ref to the jth button in the listOfMenuButtons array
            let button: UIButton = listOfMenuButtons[j]
            
            // Set the button's frame to buttonRect
            var buttonRect: CGRect = button.frame
            
            // Set the buttonRect's x coordinate value to sumOfButtonWidths
            buttonRect.origin.x = sumOfButtonWidths
            
            // Set the button's frame to the newly specified buttonRect
            button.frame = buttonRect
            
            // Add the button to the horizontally scrollable menu
            scrollMenu.addSubview(button)
            
            // Add the width of the button to the total width
            sumOfButtonWidths += button.frame.size.width
        }
        
        // Horizontally scrollable menu's content width size = the sum of the widths of all of the buttons
        // Horizontally scrollable menu's content height size = kScrollMenuHeight points
        scrollMenu.contentSize = CGSizeMake(sumOfButtonWidths, kScrollMenuHeight)
        
        /*******************************************************
        * Select and show the default auto maker upon app launch
        *******************************************************/
        
        // Hide left arrow
        leftArrowWhite.hidden = true
        
        // The first auto maker on the list is the default one to display
        let defaultButton: UIButton = listOfMenuButtons[0]
        
        // Indicate that the button is selected
        defaultButton.selected = true
        
        previousButton = defaultButton
        selectedGenre = genres[0]
        
        // Display the table view object's content for the selected auto maker
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Asks the data source to return the number of rows in a section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let moviesofGenre = applicationDelegate.dict_GenreData[selectedGenre]
        return moviesofGenre!.count


    }
    
    // Asks the data source to return a cell to insert in a particular table view location
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("MovieGenreViewCell") as UITableViewCell!
        
        let rowNumber = indexPath.row

        let moviesofGenre = applicationDelegate.dict_GenreData[selectedGenre]
        
        cell.textLabel!.text = moviesofGenre!["\(rowNumber + 1)"]!![0] as? String
        cell.detailTextLabel!.text = moviesofGenre!["\(rowNumber + 1)"]!![1] as? String
        
        let movieRating = moviesofGenre!["\(rowNumber + 1)"]!![3] as? String
        let movieRatingNoSpaces = movieRating!.stringByReplacingOccurrencesOfString("-", withString: "", options: [], range: nil)
        cell.imageView!.image = UIImage(named: movieRatingNoSpaces)

        return cell
    }


    /*
    ----------------------------------
    MARK: - Table View Delegate Method
    ----------------------------------
    */
    
     //This method is invoked when the user taps a table view row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowNumber = indexPath.row
        
        
        let moviesofGenre = applicationDelegate.dict_GenreData[selectedGenre]
        
        dataObjectToPass[0] = (moviesofGenre!["\(rowNumber + 1)"]!![0] as? String)!
        dataObjectToPass[1] = (moviesofGenre!["\(rowNumber + 1)"]!![2] as? String)!
        
        // Perform the segue named Watch Trailer
        performSegueWithIdentifier("WatchTrailer", sender: self)
        
    }
    
    /*
    -------------------------
    MARK: - Prepare For Segue
    -------------------------
    */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "WatchTrailer" {
            
            // Obtain the object reference of the destination view controller
            let genreTrailerViewController: GenreTrailerViewController = segue.destinationViewController as! GenreTrailerViewController
            
            //Pass the data object to the destination view controller object
            genreTrailerViewController.dataObjectPassed = dataObjectToPass
            
        }
    }


    /*
    -----------------------------------
    MARK: - Method to Handle Button Tap
    -----------------------------------
    */
    // This method is invoked when the user taps a button in the horizontally scrollable menu
    func buttonPressed(sender: UIButton) {
        
        let selectedButton: UIButton = sender
        
        selectedButton.selected = true
        
        if previousButton != selectedButton {
            // Selecting the selected button again should not change its title color
            previousButton.selected = false
        }
        
        previousButton = selectedButton
        
        selectedGenre = selectedButton.titleForState(UIControlState.Normal)!

        // Redisplay the table view object's content for the selected auto maker
        tableView.reloadData()
    }
    
    /*
    -----------------------------------
    MARK: - Scroll View Delegate Method
    -----------------------------------
    */
    
    // Tells the delegate when the user scrolls the content view within the receiver
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // The autoTableView object scrolling also invokes this method, in the case of which no action
        // should be taken since this method is created to handle only the scrollMenu object's scrolling.
        if scrollView == tableView {
            return
        }
        
        /*
        Content        = concatenated list of buttons
        Content Width  = sum of all button widths, sumOfButtonWidths
        Content Height = kScrollMenuHeight points
        Origin         = (x, y) values of the bottom left corner of the scroll view or content
        Sx             = Scroll View's origin x value
        Cx             = Content's origin x value
        contentOffset  = Sx - Cx
        
        Interpretation of the Arrows:
        
        IF scrolled all the way to the RIGHT THEN show only RIGHT arrow: indicating that the data (content) is
        on the right hand side and therefore, the user must *** scroll to the left *** to see the content.
        
        IF scrolled all the way to the LEFT THEN show only LEFT arrow: indicating that the data (content) is
        on the left hand side and therefore, the user must *** scroll to the right *** to see the content.
        
        5 pixels used as padding
        */
        if scrollView.contentOffset.x <= 5 {
            // Scrolling is done all the way to the RIGHT
            leftArrowWhite.hidden   = true      // Hide left arrow
            rightArrowWhite.hidden  = false     // Show right arrow
        }
        else if scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width) - 5 {
            // Scrolling is done all the way to the LEFT
            leftArrowWhite.hidden   = false     // Show left arrow
            rightArrowWhite.hidden  = true      // Hide right arrow
        }
        else {
            // Scrolling is in between. Scrolling can be done in either direction.
            leftArrowWhite.hidden   = false     // Show left arrow
            rightArrowWhite.hidden  = false     // Show right arrow
        }
    }

}