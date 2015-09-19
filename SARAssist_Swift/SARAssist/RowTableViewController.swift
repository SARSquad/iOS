//
//  RowTableViewController.swift
//  SARAssist
//
//  Created by V-FEXrt on 9/18/15.
//  Copyright (c) 2015 V-FEXrt. All rights reserved.
//

import UIKit

import Parse

class RowTableViewController: UITableViewController {

    internal var selectedArea:AreaModel = AreaModel()
    internal var currentLocation:PFGeoPoint = PFGeoPoint()
    
    private var blockRows:Array2DTyped<BlockModel> = Array2DTyped(cols: 0, rows: 0, defaultValue: BlockModel())
    
    private let formatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.formatter.dateStyle = .ShortStyle
        self.formatter.timeStyle = .FullStyle
        
        let query:PFQuery = BlockModel.query()!
        
        query.whereKey("SearchAreaID", equalTo: self.selectedArea.SearchAreaID)
        query.orderByAscending("Column")
        query.limit = 1000
        
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            if let obj:[AnyObject] = objects{
                let blocks:[BlockModel] = (obj as? [BlockModel])!
                
                var maxRow:Int = -1
                var maxCol:Int = -1
                
                
                for block:BlockModel in blocks{
                    if(block.Row.integerValue > maxRow){
                        maxRow = block.Row.integerValue
                    }
                    if(block.Column.integerValue > maxCol){
                        maxCol = block.Column.integerValue
                    }
                }
                
                self.blockRows = Array2DTyped(cols: maxCol+1, rows: maxRow+1, defaultValue: BlockModel())
                
                for block:BlockModel in blocks{
                    self.blockRows[block.Column.integerValue, block.Row.integerValue] = block
                }
                
                self.tableView.reloadData()
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
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.blockRows.rowCount()
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:RowTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RowTableViewCell

        
        //Get the first object in the current row
        let block:BlockModel = self.blockRows[indexPath.row, 0]
        
        
        if ((block.AssignedTo) != nil) {
            let user:PFUser = block.AssignedTo;
            
            
            user.fetchIfNeededInBackgroundWithBlock({ (obj:PFObject?, error:NSError?) -> Void in
                cell.title.text = user.username
                cell.subtitle.text = self.formatter.stringFromDate((obj?.updatedAt)!)
                //cell.selectionStyle = .None
                
            })

        }else{
            cell.title.text = "Not Assigned";
            let distance:Double = self.currentLocation.distanceInMilesTo(block.Location)
            
            cell.subtitle.text = String(format: "%.1f miles away", distance )
        }


        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell:RowTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! RowTableViewCell
        if(cell.title.text == "Not Assigned" || cell.title.text == PFUser.currentUser()?.username){
            
            let alertController:UIAlertController = UIAlertController(title: "Select Row?", message: "Are you sure you want to select this row?", preferredStyle: .ActionSheet)
            
            if(UI_USER_INTERFACE_IDIOM() == .Pad){
                alertController.popoverPresentationController?.sourceView = self.view
                
                alertController.popoverPresentationController!.sourceRect = CGRectMake((cell.bounds.origin.x + cell.title.bounds.size.width), cell.bounds.origin.y, 20, 20);
                
            }
            
            alertController.addAction(UIAlertAction(title: "Select Row", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                self.performSegueWithIdentifier("segue", sender: self)
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }

    }

    
    // MARK: - Navigation


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let path:NSIndexPath = self.tableView.indexPathForSelectedRow!
        
        for block:BlockModel in self.blockRows[path.row]{
            
            block.AssignedTo = PFUser.currentUser()
            block.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                if(success){
                    let cell:RowTableViewCell = self.tableView.cellForRowAtIndexPath(path) as! RowTableViewCell
                    cell.title.text = PFUser.currentUser()?.username
                    cell.subtitle.text = self.formatter.stringFromDate(block.updatedAt!)
                }
            })
        }
        
        let vc:MapViewController = segue.destinationViewController as! MapViewController
        
        vc.selectedBlocks = self.blockRows[path.row];
        vc.currentLocation = self.currentLocation
    }


}
