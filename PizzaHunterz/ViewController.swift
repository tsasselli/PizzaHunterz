//
//  ViewController.swift
//  PizzaHunterz
//
//  Created by Travis Sasselli on 8/29/16.
//  Copyright © 2016 TravisSasselli. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView?
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup () {
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = kCLHeadingFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView?.showsUserLocation = true
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        var annotationView = self.mapView?.dequeueReusableAnnotationViewWithIdentifier("PizzaAnnotationView")
        
        if(annotationView == nil){
            
            annotationView = PizzaAnnotationView(annotation: annotation, reuseIdentifier: "PizzaAnnotationView")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }

    func addAnnotationToMap() {
        let pizzaAnnotation = PizzaAnnotation(coordinate: self.currentLocation!.coordinate, title: "Yummy Pizza", subtitle: "Way to cool for school")
        self.mapView?.addAnnotation(pizzaAnnotation)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        self.currentLocation = userLocation.location
        
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 250, 250)
        self.mapView?.setRegion(region, animated: true)
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        if(motion == UIEventSubtype.MotionShake) {
            
            addAnnotationToMap()
        }
    }
}

