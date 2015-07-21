//
//  AreaModel.m
//  SARAssist
//
//  Created by V-FEXrt on 7/20/15.
//  Copyright (c) 2015 V-FEXrt. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel

@dynamic Name;
@dynamic Location;
@dynamic IsComplete;
@dynamic NorthEastLat;
@dynamic NorthEastLng;
@dynamic SouthWestLat;
@dynamic SouthWestLng;
@dynamic SearchAreaID;

+(NSString *)parseClassName{
    return @"SearchArea";
}

+(void)load{
    [AreaModel registerSubclass];
}

/*
-(void)setIsCompleteTo:(BOOL)complete{
    self[@"IsComplete"] = [NSNumber numberWithBool:complete];
}

-(CLLocationCoordinate2D)CLLoction{
    return CLLocationCoordinate2DMake([[self location] latitude], [[self location]longitude]);
}
*/

@end
