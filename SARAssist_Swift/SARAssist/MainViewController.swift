//
//  MainViewController.swift
//  SARAssist
//
//  Created by V-FEXrt on 9/18/15.
//  Copyright (c) 2015 V-FEXrt. All rights reserved.
//

import UIKit

import Parse
import ParseUI

class MainViewController: UITableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, CLLocationManagerDelegate {

    private var currentLocation:PFGeoPoint = PFGeoPoint();
    private var searchAreas:[AreaModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC / 2)), dispatch_get_main_queue()) { () -> Void in
            
            if (PFUser.currentUser() == nil || PFUser.currentUser()?.isAuthenticated() == false) { // No user logged in
                
                let logInViewController:PFLogInViewController = PFLogInViewController()
                logInViewController.delegate = self
                
                let signUpViewController:PFSignUpViewController = PFSignUpViewController()
                signUpViewController.delegate = self
                
                logInViewController.signUpController = signUpViewController
                
                self.presentViewController(logInViewController, animated: true, completion: nil)

            }
        }
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint:PFGeoPoint?, error:NSError?) -> Void in
            
            if let geo:PFGeoPoint = geoPoint{
                self.currentLocation = geo
                
                let query:PFQuery = AreaModel.query()!
                
                query.whereKey("IsComplete", equalTo: NSNumber(bool: false))
                
                query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in

                    if let err:NSError = error{
                        print("Error getting objects \(err.localizedDescription)")
                    }
                    else if let objs:[PFObject] = objects{
                        self.searchAreas = (objs as? [AreaModel])!
                        self.tableView.reloadData()
                    }
                })
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchAreas.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:MainTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MainTableViewCell

        let area:AreaModel = self.searchAreas[indexPath.row]
        
        cell.title.text = area.Name
        
        let distance:Double = self.currentLocation.distanceInMilesTo(area.Location)
        
        cell.distance.text = String(format: "%.1f miles away", distance )

        return cell
    }
    


    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let path:NSIndexPath = self.tableView.indexPathForSelectedRow!;
        
        let vc:RowTableViewController = segue.destinationViewController as! RowTableViewController
        
        vc.selectedArea = self.searchAreas[path.row]
        vc.currentLocation = self.currentLocation
    }
    

    
    //MARK: - PFLogInViewControllerDelegate
    
    // Sent to the delegate to determine whether the log in request should be submitted to the server.
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        // Check if both fields are completed
        if (!username.isEmpty && !password.isEmpty) {
            return true // Begin login process
        }
        
        let alert:UIAlertView = UIAlertView(title: "Missing Information", message: "Make sure you fill out all of the information!", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
        
        alert.show()
        
        return false // Interrupt login process
    }
    
    // Sent to the delegate when a PFUser is logged in.
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Sent to the delegate when the log in attempt fails.
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("Failed to log in")
    }
    
    // Sent to the delegate when the log in screen is dismissed.
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        print("User dismissed the logInViewController")
    }
    
    //MARK: - PFSignUpViewControllerDelegate
    
    // Sent to the delegate to determine whether the sign up request should be submitted to the server.
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        var informationComplete = true;
        
        var dict:Dictionary = info as Dictionary
        
        // loop through all of the submitted data
        for (key) in dict.keys{
            let field:String = dict[key] as! String
            
            if(field.isEmpty){
                informationComplete = false;
                break;
            }
        }
        
        // Display an alert if a field wasn't completed
        if (!informationComplete) {
            let alert:UIAlertView = UIAlertView(title: "Missing Information", message: "Make sure you fill out all of the information!", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
            
            alert.show()
        }
        
        return informationComplete;
    }
    
    // Sent to the delegate when a PFUser is signed up.
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        
    }
    
    // Sent to the delegate when the sign up attempt fails.
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("Failed to sign up...")
    }
    
    // Sent to the delegate when the sign up screen is dismissed.
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        print("User dismissed the signUpViewController")
    }
    
    
    //MARK: Logout
    func logoutButtonClicked(){
        PFUser.logOut();
    }

}
