//
//  SARAnnotation.m
//  SARAssist
//
//  Created by V-FEXrt on 7/18/15.
//  Copyright (c) 2015 V-FEXrt. All rights reserved.
//

#import "SARAnnotation.h"

@implementation SARAnnotation

- (instancetype)initWithTitle:(NSString *)title Location:(CLLocationCoordinate2D)location Color:(MKPinAnnotationColor)color
{
    self = [super init];
    if (self) {
        self.title = title;
        self.coordinate = location;
        self.color = color;
    }
    return self;
}
-(MKPinAnnotationView *)annotationView{
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"CustomPinAnnotationView"];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [btn addTarget:self action:@selector(callDelegate) forControlEvents:UIControlEventTouchUpInside];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.pinColor = self.color;
    annotationView.rightCalloutAccessoryView = btn;
    
    return annotationView;
    
}

-(void)callDelegate{
    [self.delegate buttonWasPressedOnSARAnnotation:self];
}
@end
