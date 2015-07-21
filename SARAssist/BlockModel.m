//
//  BlockModel.m
//  SARAssist
//
//  Created by V-FEXrt on 7/20/15.
//  Copyright (c) 2015 V-FEXrt. All rights reserved.
//

#import "BlockModel.h"

@implementation BlockModel

@dynamic AssignedTo;
@dynamic Column;
@dynamic Row;
@dynamic IsComplete;
@dynamic Latitude;
@dynamic Longitude;
@dynamic Location;
@dynamic SearchAreaID;


+(NSString *)parseClassName{
    return @"Block";
}

+(void)load{
    [BlockModel registerSubclass];
}

-(CLLocationCoordinate2D)CLLoction{
    return CLLocationCoordinate2DMake(self.Latitude, self.Longitude);
}

@end
