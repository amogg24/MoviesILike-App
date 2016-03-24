//
//  MyMoviesTableViewController.swift
//  MoviesILike
//
//  Need delete, and add to work
//
//  Created by Andrew Mogg on 11/5/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit

class MyMoviesTableViewController: UITableViewController {//, AddMoviesViewControllerProtocol {

    @IBOutlet var myMoviesTableView: UITableView!
    
    
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var genres = [String]()
    
    // dataObjectToPass is the data object to pass to the downstream view controller
    var dataObjectToPass: [String] = ["", ""]
    
    /*
    -----------------------
    MARK: - View Life Cycle
    -----------------------
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Set up the Edit button on the left of the navigation bar to enable editing of the table view rows
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        // Set up the Add button on the right of the navigation bar to call the addCity method when tapped
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addMovie:")
        self.navigationItem.rightBarButtonItem = addButton
        
        /*
        allKeys returns a new array containing the dictionary’s keys as of type AnyObject.
        Therefore, typecast the AnyObject type keys to be of type String.
        The keys in the array are *unordered*; therefore, they need to be sorted.
        */
        genres = applicationDelegate.dict_GenreData.allKeys as! [String]
        
        // Sort the country names within itself in alphabetical order
        genres.sortInPlace { $0 < $1 }
    }
    
    /*
    -----------------------
    MARK: - Add City Method
    -----------------------
    */
    
    // The addMovie method is invoked when the user taps the Add button created in viewDidLoad() above.
    func addMovie(sender: AnyObject) {
        
        // Perform the segue named AddMovie
        performSegueWithIdentifier("AddMovie", sender: self)
    }
    
    /*
    -----------------------------------------------------
    MARK: - AddCityViewControllerProtocol Protocol Method
    -----------------------------------------------------
    */
    //func addMoviesViewController(controller: AddMoviesViewController, didFinishWithSave save: Bool) {
    @IBAction func UnwindToMyMoviesTableViewController(segue: UIStoryboardSegue) {
        //if save
        if segue.identifier == "AddMovie-Save" {
            let controller: AddMoviesViewController = segue.sourceViewController as! AddMoviesViewController
            
            //Get the text field and segmented control data
            let movieNameEntered: String = controller.movieNameTextField.text!
            let topStarsEntered: String = controller.topStarsTextField.text!
            let movieGenreEntered: String = controller.movieGenreTextField.text!
            let movieTrailerEntered: String = controller.movieTrailerTextField.text!
            let movieRatingEntered: Int = controller.movieRatingSegmentedControl.selectedSegmentIndex
            var movieRating: String = ""
            switch movieRatingEntered {
                case 0: movieRating = "G"
                case 1: movieRating = "PG"
                case 2: movieRating = "PG13"
                case 3: movieRating = "R"
                case 4: movieRating = "NC17"
                default:
                        print("INVALID SELECTION ID IN RATING SELECTOR")
                        return
                    }
            if (movieNameEntered == "" || topStarsEntered == "" || movieGenreEntered == "" || movieTrailerEntered == "") {
                let alertController = UIAlertController(title: "Must Enter all Fields",
                    message: "All text fields must have input",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                // Create a UIAlertAction object and add it to the alert controller
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                // Present the alert controller by calling the presentViewController method
                presentViewController(alertController, animated: true, completion: nil)
            }
            else {
            if genres.contains(movieGenreEntered) {
                
                //The genre already exists
                let moviesFormovieGenreEntered = applicationDelegate.dict_GenreData[movieGenreEntered]!
                
    
                let newMovieEntry: [String] = [movieNameEntered, topStarsEntered, movieTrailerEntered, movieRating]
                
                let genreCount: Int  = moviesFormovieGenreEntered.count
                
                let key = String(genreCount + 1)
                
                moviesFormovieGenreEntered.setValue(newMovieEntry, forKey: key)
                
                // Update the new list of movies for the Genre in the Objective-C dictionary
                applicationDelegate.dict_GenreData.setValue(moviesFormovieGenreEntered, forKey: movieGenreEntered)
            }
                else {   // The entered Genre name does not exist in the current dictionary
                let newGenre: NSMutableDictionary = ["1" : [movieNameEntered, topStarsEntered, movieTrailerEntered, movieRating]]

                applicationDelegate.dict_GenreData.setObject(newGenre, forKey: movieGenreEntered)
            }
            
            genres = applicationDelegate.dict_GenreData.allKeys as! [String]
            
            // Sort the country names within itself in alphabetical order
            genres.sortInPlace { $0 < $1 }
            
            // Reload the rows and sections of the Table View countryCityTableView
            myMoviesTableView.reloadData()
            }
        }
    }
    
    /*
    --------------------------------------
    MARK: - Table View Data Source Methods
    --------------------------------------
    */
    
    // We are implementing a Grouped table view style as we selected in the storyboard file.
    
    //----------------------------------------
    // Return Number of Sections in Table View
    //----------------------------------------
    
    // Each table view section corresponds to a country
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return genres.count
    }
    
    //---------------------------------
    // Return Number of Rows in Section
    //---------------------------------
    
    // Number of rows in a genre (section) = Number of Movies in the genre section)
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Obtain the name of the given genre
        let genre = genres[section]
        
        let moviesofGenre = applicationDelegate.dict_GenreData[genre]
        return moviesofGenre!.count
    }
    
    //-----------------------------
    // Set Title for Section Header
    //-----------------------------
    
    // Set the table view section header to be the genre name
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        
        return genres[section]
    }
    
    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyMoviesView", forIndexPath: indexPath) as UITableViewCell
        
        let sectionNumber = indexPath.section
        let rowNumber = indexPath.row
        
        let genre = genres[sectionNumber]
        
        let moviesofGenre = applicationDelegate.dict_GenreData[genre]

        cell.textLabel!.text = moviesofGenre!["\(rowNumber + 1)"]!![0] as? String
        cell.detailTextLabel!.text = moviesofGenre!["\(rowNumber + 1)"]!![1] as? String
        
        let movieRating = moviesofGenre!["\(rowNumber + 1)"]!![3] as? String
        let movieRatingNoSpaces = movieRating!.stringByReplacingOccurrencesOfString("-", withString: "", options: [], range: nil)
        cell.imageView!.image = UIImage(named: movieRatingNoSpaces)
        
        return cell
    }
    
    //-------------------------------
    // Allow Editing of Rows (Movies)
    //-------------------------------
    
    // We allow each row (city) of the table view to be editable, i.e., deletable or movable
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    //---------------------
    // Delete Button Tapped
    //---------------------
    
     //This is the method invoked when the user taps the Delete button in the Edit mode
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {   // Handle the Delete action
            
            let genreToDelete = genres[indexPath.section]
            
            let moviesOfGenre = applicationDelegate.dict_GenreData[genreToDelete]

            moviesOfGenre!.removeObjectForKey!("\(indexPath.row)")
            if moviesOfGenre!.allKeys.count == 1 {
                // If no movies remains in the array after deletion, then we need to also delete the genre
                applicationDelegate.dict_GenreData.removeObjectForKey(genreToDelete)
                
                // Since the dictionary has been changed, obtain the genre names again
                genres = applicationDelegate.dict_GenreData.allKeys as! [String]
                
                // Sort the genre names within itself in alphabetical order
                genres.sortInPlace { $0 < $1 }
                
                // Reload the rows and sections of the Table View MyMoviesTableView
                myMoviesTableView.reloadData()

            }
            else {
                // At least one more movies remains in the array; therefore, the genre stays.
                for var index = indexPath.row + 2; index <= moviesOfGenre!.count+1; index++
                {
                    let temp = moviesOfGenre!["\(index)"]!
                    moviesOfGenre!.removeObjectForKey!("\(index)")
                    moviesOfGenre?.setValue(temp, forKey: "\(index-1)")
                }
                applicationDelegate.dict_GenreData.setValue(moviesOfGenre, forKey: genreToDelete)
                
                // Reload the rows and sections of the Table View MyMovieTableView
                myMoviesTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
            


        }
    }

    //---------------------------
    // Movement of Movies Attempted
    //---------------------------
    
    /*
    This method is invoked to carry out the row (movies) movement after the method
    tableView: targetIndexPathForMoveFromRowAtIndexPath: toProposedIndexPath: approved the move.
    */
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        let genre = genres[fromIndexPath.section]
        
        // Row number to move FROM
        let rowNumberFrom   = fromIndexPath.row
        
        // Row number to move TO
        let rowNumberTo     = toIndexPath.row
        
        let moviesOfTheGenre = applicationDelegate.dict_GenreData[genre]
        
        // Movie name to move
        let MovieNameToMove  = moviesOfTheGenre!["\(rowNumberFrom + 1)"]
        let MovieNameToMove2 = moviesOfTheGenre!["\(rowNumberTo + 1)"]
        moviesOfTheGenre!.setValue(MovieNameToMove, forKey: "\(rowNumberTo+1)")
        moviesOfTheGenre!.setValue(MovieNameToMove2, forKey: "\(rowNumberFrom+1)")
        
        applicationDelegate.dict_GenreData.setValue(moviesOfTheGenre, forKey: genre)

    }

//    -----------------------------------------------------
//     Allow Movement of Rows (Movies) within their Genre
//    -----------------------------------------------------
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    /*
    -----------------------------------
    MARK: - Table View Delegate Methods
    -----------------------------------
    */
    
    //--------------------------
    // Selection of a Movie(Row)
    //--------------------------
    
    // Tapping a row (movie) displays its trailer
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sectionNumber = indexPath.section
        let rowNumber = indexPath.row
        
        let genre = genres[sectionNumber]
        
        let moviesofGenre = applicationDelegate.dict_GenreData[genre]
        
        dataObjectToPass[0] = (moviesofGenre!["\(rowNumber + 1)"]!![0] as? String)!
        dataObjectToPass[1] = (moviesofGenre!["\(rowNumber + 1)"]!![2] as? String)!
        
        // Perform the segue named WatchTrailer
        performSegueWithIdentifier("WatchTrailer", sender: self)
    }

    
    //--------------------------
    // Movement of Movie Approval
    //--------------------------
    
    // This method is invoked when the user attempts to move a row (movie)
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        
        let genreFrom = genres[sourceIndexPath.section]
        let genreTo = genres[proposedDestinationIndexPath.section]
        
        if genreFrom != genreTo {
            
            // The user attempts to move a movie from one genre to another, which is prohibited
            
            /*
            Create a UIAlertController object; dress it up with title, message, and preferred style;
            and store its object reference into local constant alertController
            */
            let alertController = UIAlertController(title: "Move Not Allowed!",
                message: "Order movies according to your liking only within the same genre!",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            presentViewController(alertController, animated: true, completion: nil)
            
            return sourceIndexPath  // The row (movie) movement is denied
        }
        else {
            return proposedDestinationIndexPath  // The row (movie) movement is approved
        }
        
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
            let movieTrailerViewController: MovieTrailerViewController = segue.destinationViewController as! MovieTrailerViewController
            
            //Pass the data object to the destination view controller object
            movieTrailerViewController.dataObjectPassed = dataObjectToPass
            
        }
    }
}
