//
//  BlockModel.swift
//  SARAssist
//
//  Created by V-FEXrt on 9/18/15.
//  Copyright (c) 2015 V-FEXrt. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class BlockModel: PFObject, PFSubclassing {
   /*

@property BOOL IsComplete;

*/
    
    override internal class func initialize() {
        registerSubclass()
    }
    
    internal class func parseClassName() -> String {
        return "Block"
    }
    
    var CoreLocation:CLLocationCoordinate2D{
        get{ return CLLocationCoordinate2DMake(self.Latitude.doubleValue, self.Longitude.doubleValue);}
    }
    
    @NSManaged internal var Name: String!
    @NSManaged internal var SearchAreaID: String!
    
    @NSManaged internal var Location: PFGeoPoint!
    @NSManaged internal var Latitude: NSNumber!
    @NSManaged internal var Longitude: NSNumber!
    @NSManaged internal var AssignedTo: PFUser!
    @NSManaged internal var Column: NSNumber!
    @NSManaged internal var Row: NSNumber!
    @NSManaged var isComplete: NSNumber
}
