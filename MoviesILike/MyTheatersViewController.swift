//
//  MyTheatersViewController.swift
//  MoviesILike
//
//  Created by Andrew Mogg on 11/5/15.
//  Copyright © 2015 Andrew Mogg. All rights reserved.
//

import UIKit

class MyTheatersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var mapSegmentedControl: UISegmentedControl!
    var showtimeObject = ""
    
    // Declare a property to contain the absolute file path for the maps.html file
    var mapsHtmlFilePath: String?
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var dataObjectToPass: [String] = ["googleMapQuery", "directionsType", "theaterName", "showtimeLoc"]
    
    var viewShownFirstTime = true
    
    var favoriteTheaters = [String]()
    var theaterLoc = [String]()
    
    var theaterName = ""
    var theaterAddress = ""

    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        // Set up the Edit button on the left of the navigation bar to enable editing of the table view rows
         self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editTheater:")
        
        // Set up the Add button on the right of the navigation bar to call the addCity method when tapped
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addTheater:")
        self.navigationItem.rightBarButtonItem = addButton

        // Obtain the absolute file path to the maps.html file in the main bundle
        mapsHtmlFilePath = NSBundle.mainBundle().pathForResource("maps", ofType: "html")
        
        favoriteTheaters = applicationDelegate.dict_MyTheaters.allKeys as! [String]
        theaterLoc = applicationDelegate.dict_MyTheaters.allValues as! [String]

    }
    
    /*
    -----------------------
    MARK: - Add Theater Method
    -----------------------
    */
    
    // The addTheater method is invoked when the user taps the Add button created in viewDidLoad() above.
    func addTheater(sender: AnyObject) {
        
        // Perform the segue named AddTheater
        performSegueWithIdentifier("AddTheater", sender: self)
    }

    
    

    
        /*
        -----------------------------------------------------
        MARK: - AddTheaterViewControllerProtocol Unwind Method
        -----------------------------------------------------
        */
    @IBAction func UnwindToMyMoviesTableViewController(segue: UIStoryboardSegue) {
        //if save
        if segue.identifier == "AddTheater-Save" {
            let controller: AddTheaterViewController = segue.sourceViewController as! AddTheaterViewController
            let movieTheaterEntered: String = controller.movieTheaterNameToAdd.text!
            let movieTheaterAddressEntered: String = controller.movieTheaterAddressToAdd.text!
           
            if (movieTheaterEntered == "" || movieTheaterAddressEntered == "") {
                let alertController = UIAlertController(title: "Must Enter all Fields",
                    message: "All text fields must have input",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                // Create a UIAlertAction object and add it to the alert controller
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                // Present the alert controller by calling the presentViewController method
                presentViewController(alertController, animated: true, completion: nil)
            }
            else {
                applicationDelegate.dict_MyTheaters.setObject(movieTheaterAddressEntered, forKey: movieTheaterEntered)
                favoriteTheaters = applicationDelegate.dict_MyTheaters.allKeys as! [String]
                theaterLoc = applicationDelegate.dict_MyTheaters.allValues as! [String]

                // Reload the rows and sections of the Pickerview
                pickerView.reloadAllComponents()
            }
        }
        
        if segue.identifier == "EditTheater-Save" {
            let controller: EditTheaterViewController = segue.sourceViewController as! EditTheaterViewController
           
            let movieTheaterEntered: String = controller.theaterNameTextField.text!
            let movieTheaterAddressEntered: String = controller.theaterAddressTextField.text!
            
            if (movieTheaterAddressEntered == "" || movieTheaterEntered == "") {
                let alertController = UIAlertController(title: "Must Enter all Fields",
                    message: "All text fields must have input",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                // Create a UIAlertAction object and add it to the alert controller
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                // Present the alert controller by calling the presentViewController method
                presentViewController(alertController, animated: true, completion: nil)
            }
            else {
            
                applicationDelegate.dict_MyTheaters.setObject(movieTheaterAddressEntered, forKey: movieTheaterEntered)
            
                favoriteTheaters = applicationDelegate.dict_MyTheaters.allKeys as! [String]
                theaterLoc = applicationDelegate.dict_MyTheaters.allValues as! [String]

                // Reload the rows and sections of the Pickerview
                pickerView.reloadAllComponents()
            }
        }
        
        if segue.identifier == "EditTheater-Delete" {
            let controller: EditTheaterViewController = segue.sourceViewController as! EditTheaterViewController

            let movieTheaterEntered: String = controller.theaterNameTextField.text!
            let movieTheaterAddressEntered: String = controller.theaterAddressTextField.text!
            
            applicationDelegate.dict_MyTheaters.removeObjectForKey(movieTheaterEntered)
            favoriteTheaters = applicationDelegate.dict_MyTheaters.allKeys as! [String]
        
            pickerView.reloadAllComponents()
        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    override func viewWillAppear(animated: Bool) {
        
        // Obtain the number of the row in the middle of the theater names list
        let numberOfTheaters = favoriteTheaters.count
        let numberOfRowToShow = Int(numberOfTheaters / 2)
        
        // Show the picker view of VT place names from the middle
        pickerView.selectRow(numberOfRowToShow, inComponent: 0, animated: false)
        
        // Deselect the earlier selected directions type
        mapSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
        
        if viewShownFirstTime {
            viewShownFirstTime = false
            // Do not clear "Selected VT place FROM" and "Selected VT place TO"
        } else {
            // Clear the earlier selections
            locationTextField.text = ""
        }
    }
        /*
        -------------------------
        MARK: - Map Type Selected
        -------------------------
        */
        @IBAction func mapTypeSelected(sender: UISegmentedControl) {
            let indexNumber: Int = pickerView.selectedRowInComponent(0)
            let theaterName = favoriteTheaters[indexNumber]
            
            //dataObjectToPass[1] = mapType
            let address = theaterLoc[indexNumber]

            
            // A Google map query parameter cannot have spaces. Therefore, replace each space with +
            let addressToShowOnMap = address.stringByReplacingOccurrencesOfString(" ", withString: "+", options: [], range: nil)
    
            var googleMapQuery: String = ""
            var mapType: String = ""
            
            switch sender.selectedSegmentIndex {
                
            case 0:   // Standard map type selected
                googleMapQuery = mapsHtmlFilePath! + "?place=\(addressToShowOnMap)&maptype=ROADMAP&zoom=16"
                mapType = "Roadmap"
                
            case 1:   // Satellite map type selected
                googleMapQuery = mapsHtmlFilePath! + "?place=\(addressToShowOnMap)&maptype=SATELLITE&zoom=16"
                mapType = "Satellite"
                
            case 2:   // Hybrid map type selected
                googleMapQuery = mapsHtmlFilePath! + "?place=\(addressToShowOnMap)&maptype=HYBRID&zoom=16"
                mapType = "Hybrid"
            case 3:   // Terrain map type selected
                googleMapQuery = mapsHtmlFilePath! + "?place=\(addressToShowOnMap)&maptype=TERRAIN&zoom=16"
                mapType = "Terrain"
            default:
                return
            }
            
            dataObjectToPass[0] = googleMapQuery
            dataObjectToPass[1] = mapType
            dataObjectToPass[2] = theaterName

            
            // Perform the segue named "Show Location on Map"
            performSegueWithIdentifier("Show Location on Map", sender: self)
    }
    
    
    /*
    -----------------------
    MARK: - Edit Theater Method
    -----------------------
    */
    func editTheater(sender: AnyObject)
    {
        let selectedRowNumber = pickerView.selectedRowInComponent(0)
        showtimeObject = favoriteTheaters[selectedRowNumber]
        theaterName = showtimeObject
        theaterAddress = theaterLoc[selectedRowNumber]

        // Perform the segue amed AddMovie
        performSegueWithIdentifier("EditTheater", sender: self)
    }

    /*
    ------------------------
    MARK: - IBAction Methods
    ------------------------
    */
    @IBAction func keyboardDone(sender: UITextField) {
        
        // Deactivate the Address Text Field object and remove the Keyboard
        sender.resignFirstResponder()
        let location = (locationTextField?.text!)!
        // A Google map query parameter cannot have spaces. Therefore, replace each space with +
        let addressToShowOnMap = location.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil)
        showtimeObject = addressToShowOnMap
        performSegueWithIdentifier("Showtimes", sender: self)
    }
    
    @IBAction func backgroundTouch(sender: UIControl) {
        
        // Deactivate the Address Text Field object and remove the Keyboard
        locationTextField!.resignFirstResponder()
    }
    
    
        /*
        -------------------------
        MARK: - Prepare for Segue
        -------------------------
        
        This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
        You never call this method. It is invoked by the system.
        */
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
            
            if segue.identifier == "Show Location on Map" {
                
                // Obtain the object reference of the destination (downstream) view controller
                let locationViewController: TheaterWebViewViewController = segue.destinationViewController as! TheaterWebViewViewController
                
                /*
                This view controller creates the dataObjectToPass and passes it (by value) to the downstream view controller
                LocationViewController by copying its content into LocationViewController's property dataObjectPassed.
                */
                locationViewController.dataObjectPassed = dataObjectToPass
            }
            else if segue.identifier == "Showtimes" {
                
                // Obtain the object reference of the destination (downstream) view controller
                let showtimesViewController: ShowtimesWebViewController = segue.destinationViewController as! ShowtimesWebViewController
                
                /*
                This view controller creates the dataObjectToPass and passes it (by value) to the downstream view controller
                LocationViewController by copying its content into LocationViewController's property dataObjectPassed.
                */
                showtimesViewController.location = showtimeObject
            }
            else if segue.identifier == "EditTheater" {
                
                // Obtain the object reference of the destination view controller
                let editTheaterViewController: EditTheaterViewController = segue.destinationViewController as! EditTheaterViewController
                
                // Under the Delegation Design Pattern, set the addCityViewController's delegate to be self
                editTheaterViewController.dataObjectPassed[0] = theaterName
                editTheaterViewController.dataObjectPassed[1] = theaterAddress
            }
        }
    
    
    /*
    ----------------------------------------
    MARK: - UIPickerView Data Source Methods
    ----------------------------------------
    */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return favoriteTheaters.count
    }
    
    /*
    ------------------------------------
    MARK: - UIPickerView Delegate Method
    ------------------------------------
    */
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return favoriteTheaters[row]
    }
    
  
}
