//
//  MapViewController.h
//  SARAssist
//
//  Created by V-FEXrt on 7/18/15.
//  Copyright (c) 2015 V-FEXrt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SARAnnotation.h"

@interface MapViewController : UIViewController<MKMapViewDelegate, SARAnnotationDelegate>

@property (nonatomic, strong)NSArray *selectedBlocks;

@end

