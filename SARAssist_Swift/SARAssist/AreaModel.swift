//
//  AreaModel.swift
//  SARAssist
//
//  Created by V-FEXrt on 9/18/15.
//  Copyright (c) 2015 V-FEXrt. All rights reserved.
//

import UIKit
import Parse

class AreaModel: PFObject, PFSubclassing {
    
    override internal class func initialize() {
        registerSubclass()
    }
    
    internal class func parseClassName() -> String {
        return "SearchArea"
    }
    
    @NSManaged internal var Name: String!
    @NSManaged internal var SearchAreaID: String!
    
    @NSManaged internal var Location: PFGeoPoint!
    @NSManaged internal var NorthEastLat: NSNumber!
    @NSManaged internal var NorthEastLng: NSNumber!
    @NSManaged internal var SouthWestLat: NSNumber!
    @NSManaged internal var SouthWestLng: NSNumber!
    

    //Special case for Bool values
    /*var IsComplete: Bool {
        get { return self["IsComplete"] as! Bool }
        set { self["IsComplete"] = newValue }
    }*/


}
