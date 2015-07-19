//
//  SARAnnotation.h
//  SARAssist
//
//  Created by V-FEXrt on 7/18/15.
//  Copyright (c) 2015 V-FEXrt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol SARAnnotationDelegate <NSObject>

-(void)buttonWasPressedOnSARAnnotation:(id)annotation;

@end

@interface SARAnnotation : NSObject<MKAnnotation>

@property (retain) id<SARAnnotationDelegate> delegate;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign)MKPinAnnotationColor color;

-(id)initWithTitle:(NSString*)title Location:(CLLocationCoordinate2D)location Color:(MKPinAnnotationColor)color;

-(MKPinAnnotationView *)annotationView;



@end