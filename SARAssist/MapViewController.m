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
    
    [self.map setDelegate:self];
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (geoPoint) {
            //Save the current location
            self.currentLocation = geoPoint;
            
            [self positionMap:self.map ToLocation:self.currentLocation];
            

            [self addAllAnnotations];
            
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

    [map setRegion:region animated:NO];
}

-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }

    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[SARAnnotation class]])
    {

        SARAnnotation *ann = (SARAnnotation*)annotation;
        
        MKPinAnnotationView *pinView;
        
        if (ann.color == MKPinAnnotationColorRed) {
            pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"redColorPin"];
        }else{
            pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"greenColorPin"];
        }
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [ann annotationView];


        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }

    return nil;
}

#pragma mark SARAnnotation Delegate
-(void)buttonWasPressedOnSARAnnotation:(id)annotation{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Mark as complete?" message:@"Are you sure you want to mark this block as complete?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        alertController.popoverPresentationController.sourceView = self.view;
        
        alertController.popoverPresentationController.sourceRect = CGRectMake((self.view.bounds.origin.x /2) - 10, (self.view.bounds.origin.y / 2)-10, 20, 20);
        
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Complete Pin" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        

        SARAnnotation *ann = (SARAnnotation*)annotation;
        
        //PFObject *blockToUpdate;
        
        NSString *a = [ann.title substringFromIndex:9];
        NSString *b = [a substringToIndex:1];
        int col = [b intValue];
        
        /*for (PFObject *obj in self.selectedBlocks) {
            if ([obj[@"Column"]intValue] == col) {
                blockToUpdate = obj;
                break;
            }
        }*/

        PFObject *blockToUpdate = self.selectedBlocks[col];
        
        blockToUpdate[@"IsComplete"] = [NSNumber numberWithBool:YES];
        
        [blockToUpdate saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                
                //refresh the annotation pins
                [self removeAllAnnotations];
                [self addAllAnnotations];
                
            } else {
                // There was a problem, check error.description
                NSLog(@"Failure");
            }
        }];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];

}

-(void)removeAllAnnotations
{
    //Remove all added annotations
    [self.map removeAnnotations:self.map.annotations];

}

-(void)addAllAnnotations{
    
    for (PFObject *obj in self.selectedBlocks) {
        
        NSString *title = [NSString stringWithFormat:@"R: %d, C: %d", [obj[@"Row"]intValue], [obj[@"Column"]intValue]];
        PFGeoPoint *pinLocation = obj[@"Location"];
        
        MKPinAnnotationColor color = MKPinAnnotationColorRed;
        
        if ([obj[@"IsComplete"] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            color = MKPinAnnotationColorGreen;
        }
        
        SARAnnotation *annotation = [[SARAnnotation alloc] initWithTitle:title Location:CLLocationCoordinate2DMake(pinLocation.latitude, pinLocation.longitude) Color:color];
        
        annotation.delegate = self;
        
        [self.map addAnnotation:annotation];
        
    }
    
    
}

@end
