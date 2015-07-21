//
//  AreaModel.h
//  SARAssist
//
//  Created by V-FEXrt on 7/20/15.
//  Copyright (c) 2015 V-FEXrt. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import <CoreLocation/CoreLocation.h>

@interface AreaModel : PFObject<PFSubclassing>

+ (NSString*)parseClassName;

@property (retain)NSString *Name;
@property (retain)PFGeoPoint *Location;
@property BOOL IsComplete;
@property (retain)NSNumber *NorthEastLat;
@property (retain)NSNumber *NorthEastLng;
@property (retain)NSNumber *SouthWestLat;
@property (retain)NSNumber *SouthWestLng;
@property (retain)NSString *SearchAreaID;

@end
