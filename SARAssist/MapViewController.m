//
//  MapViewController.m
//  SARAssist
//
//  Created by V-FEXrt on 7/18/15.
//  Copyright (c) 2015 V-FEXrt. All rights reserved.
//

#import "MapViewController.h"
#import <Parse/Parse.h>

@interface MapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) PFGeoPoint *currentLocation;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (geoPoint) {
            //Save the current location
            self.currentLocation = geoPoint;
            
            [self positionMap:self.map ToLocation:self.currentLocation];
            
            //[self positionMap:self.map ToLocation:self.selectedBlocks[0][@"Location"]];
            
            for (PFObject *obj in self.selectedBlocks) {
                [self addLocation:obj[@"Location"] toMap:self.map];
            }
            
        }
        else
        {
        }
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)positionMap:(MKMapView*)map ToLocation:(PFGeoPoint*)location{
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = location.latitude;
    region.center.longitude = location.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;

    [map setRegion:region animated:YES];
}
-(void)addLocation:(PFGeoPoint*)location toMap:(MKMapView*)map{
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:CLLocationCoordinate2DMake(location.latitude, location.longitude)];
    [annotation setTitle:@"Title"];
    [map addAnnotation:annotation];
    
}

@end
