//
//  BlockModel.h
//  SARAssist
//
//  Created by V-FEXrt on 7/20/15.
//  Copyright (c) 2015 V-FEXrt. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import <CoreLocation/CoreLocation.h>

@interface BlockModel : PFObject<PFSubclassing>

+ (NSString*)parseClassName;

@property (retain)PFUser *AssignedTo;
@property int Column;
@property int Row;
@property BOOL IsComplete;
@property double Latitude;
@property double Longitude;
@property (retain)PFGeoPoint *Location;
@property (retain) NSString *SearchAreaID;

-(CLLocationCoordinate2D)CLLoction;


@end
