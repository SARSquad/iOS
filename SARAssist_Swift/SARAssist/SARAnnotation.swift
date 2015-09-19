//
//  SARAnnotation.swift
//  SARAssist
//
//  Created by V-FEXrt on 9/19/15.
//  Copyright © 2015 V-FEXrt. All rights reserved.
//

import UIKit
import MapKit

protocol SARAnnotationDelegate{
    func annotationWasSelected(annotation:SARAnnotation)
}

class SARAnnotation: NSObject, MKAnnotation {
    
    @objc var coordinate: CLLocationCoordinate2D
    @objc var title: String?
    internal var color:MKPinAnnotationColor
    internal var delegate:SARAnnotationDelegate?
    internal var row:Int = 0
    internal var column:Int = 0
    
    init(coordinate: CLLocationCoordinate2D, title: String, color: MKPinAnnotationColor) {
        self.coordinate = coordinate
        self.title = title
        self.color = color
    }
    
    func annotationView() -> MKPinAnnotationView{
        let annotationView:MKPinAnnotationView = MKPinAnnotationView(annotation: self, reuseIdentifier: "CustomPinAnnotationView")
        let btn:UIButton = UIButton(type: .InfoDark)
        btn.addTarget(self, action: Selector("callDelegate"), forControlEvents: .TouchUpInside)
        
        annotationView.enabled = true
        annotationView.canShowCallout = true
        annotationView.pinColor = self.color
        annotationView.rightCalloutAccessoryView = btn
        
        return annotationView
    }
    
    func callDelegate(){
        self.delegate?.annotationWasSelected(self);
    }

}
