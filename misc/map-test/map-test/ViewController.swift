//
//  ViewController.swift
//  map-test
//
//  Created by Brian Kobashikawa on 2/22/15.
//  Copyright (c) 2015 Brian Kobashikawa. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //let location: CLLocationCoordinate2D = self.mapView.userLocation.coordinate;
        //self.mapView.delegate = self;
        //self.mapView.setCenterCoordinate(location, animated: true);
        self.mapView.showsUserLocation = true;
        
        let missionDistrictLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.76, longitude: -122.42);
        let regionSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01);
        let region: MKCoordinateRegion = MKCoordinateRegion(center: missionDistrictLocation, span: regionSpan);
        
        let pins: [MKPointAnnotation] = [MKPointAnnotation(), MKPointAnnotation(), MKPointAnnotation()];
        pins[0].coordinate = CLLocationCoordinate2D(latitude: 37.76, longitude: -122.42);
        pins[1].coordinate = CLLocationCoordinate2D(latitude: 37.7625, longitude: -122.42);
        pins[2].coordinate = CLLocationCoordinate2D(latitude: 37.7625, longitude: -122.4225);
        
        self.mapView.setRegion(region, animated: true);
        self.mapView.addAnnotations(pins);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

