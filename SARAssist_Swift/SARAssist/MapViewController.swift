//
//  MapViewController.swift
//  SARAssist
//
//  Created by V-FEXrt on 9/19/15.
//  Copyright © 2015 V-FEXrt. All rights reserved.
//

import UIKit
import MapKit

import Parse

class MapViewController: UIViewController, MKMapViewDelegate, SARAnnotationDelegate {

    internal var selectedBlocks:[BlockModel] = []
    internal var currentLocation:PFGeoPoint = PFGeoPoint()
    
    
    @IBOutlet private var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.map.delegate = self
        
        positionMap(self.map, location: self.currentLocation)
        addAllAnnotations()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func positionMap(map:MKMapView, location:PFGeoPoint){
        let spanX:Double = 0.00725;
        let spanY:Double = 0.00725;
        var region:MKCoordinateRegion = MKCoordinateRegion();
        region.center.latitude = location.latitude;
        region.center.longitude = location.longitude;
        region.span.latitudeDelta = spanX;
        region.span.longitudeDelta = spanY;
        
        map.setRegion(region, animated: false)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if(annotation.isKindOfClass(MKUserLocation)){
            return nil
        }
        if(annotation.isKindOfClass(SARAnnotation)){
            let ann:SARAnnotation = annotation as! SARAnnotation
            
            var pinView:MKPinAnnotationView?
            
            if(ann.color == MKPinAnnotationColor.Red){
                pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("redColorPin") as? MKPinAnnotationView
            }else{
                pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("greenColorPin") as? MKPinAnnotationView
            }
            
            if(pinView == nil){
                pinView = ann.annotationView()
            }else{
                pinView!.annotation = annotation
            }
            return pinView
        }
        return nil
    }
    
    func removeAllAnnotations(){
    //Remove all added annotations
        self.map.removeAnnotations(self.map.annotations)
    
    }
    
    func addAllAnnotations(){
        for block:BlockModel in self.selectedBlocks{
            let title:String = "R: \(block.Row), C: \(block.Column)"
            var color:MKPinAnnotationColor = MKPinAnnotationColor.Red
            
            if(block.isComplete.isEqualToNumber(NSNumber(bool: true))){
                color = MKPinAnnotationColor.Green
            }
            let annotation:SARAnnotation = SARAnnotation(coordinate: block.CoreLocation, title: title, color: color)
            annotation.delegate = self
            annotation.row = block.Row.integerValue
            annotation.column = block.Column.integerValue
            
            self.map.addAnnotation(annotation)
        }
    }
    
    // MARK: - SARAnnotation Delegate
    func annotationWasSelected(annotation:SARAnnotation){
        let alertController:UIAlertController = UIAlertController(title: "Mark as complete?", message: "Are you sure you want to mark this block as complete?", preferredStyle: .ActionSheet)
        
        if(UI_USER_INTERFACE_IDIOM() == .Pad){
            alertController.popoverPresentationController?.sourceView = self.view
            alertController.popoverPresentationController!.sourceRect = CGRectMake((self.view.bounds.origin.x / 2) - 10, (self.view.bounds.origin.y / 2)-10, 20, 20);
        }
        
        alertController.addAction(UIAlertAction(title: "Complete Pin", style: .Default, handler: { (UIAlertAction) -> Void in
            
            let block:BlockModel = self.selectedBlocks[annotation.row]
            block.isComplete = NSNumber(bool: true)
            
            block.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                if(success){
                    self.removeAllAnnotations()
                    self.addAllAnnotations()
                }else{
                    print("Error \(error?.description)")
                }
            })
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
