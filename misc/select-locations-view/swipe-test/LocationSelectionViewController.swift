//
//  LocationSelectionViewController.swift
//  swipe-test
//
//  Created by yahoo on 2/21/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

import UIKit
import MapKit
import Parse

class LocationSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, MKMapViewDelegate {
	
	let CellReuseIdentifier = "LocationCollectionViewCell"
	let AddedTitle = "added"
	
	var originalCenter: CGPoint!
	var currentCard: LocationCollectionViewCell!
	var currentIndexPath: NSIndexPath!
	var cardCount = 10
	var cardNumbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
	var locations: [PFObject]! = []
	var selectedLocationCount = 0
	
	var missionDistrictLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.76, longitude: -122.42);
	var regionSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02);
	var region: MKCoordinateRegion!
	var currentAnnotation: MKPointAnnotation!
	var currentCoordinate: CLLocationCoordinate2D!
	var currentLocationName: String!
	var selectedAnnotations: [MKPointAnnotation]! = []

	
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet var cardPanRecognizer: UIPanGestureRecognizer!
	
	@IBOutlet weak var dashboardDurationLabel: UILabel!
	@IBOutlet weak var dashboardPlacesLabel: UILabel!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None);
		navigationController?.navigationBarHidden = true;
		
		var nib = UINib(nibName: "LocationCollectionViewCell", bundle: nil)
		
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.registerNib(nib, forCellWithReuseIdentifier: CellReuseIdentifier)
		
		cardPanRecognizer.delegate = self
		
		region = MKCoordinateRegion(center: self.missionDistrictLocation, span: regionSpan);
		
		getLocations()
		updateDashboard()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func getLocations() {
		var query = PFQuery(className: "Location")

		query.findObjectsInBackgroundWithBlock {
			(objects: [AnyObject]!, error: NSError!) -> Void in
			if error == nil {
				self.locations = objects as [PFObject]
				self.collectionView.reloadData()
				println(self.locations.count)
			} else {
				// Log details of the failure
				NSLog("Error: %@ %@", error, error.userInfo!)
			}
		}
	}
	
	func updateDashboard() {
		dashboardDurationLabel.text = "\(selectedLocationCount * 5) min"
		dashboardPlacesLabel.text = "\(selectedLocationCount) places, \(selectedLocationCount * 2) mi total"
	}
	
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		//#warning Incomplete method implementation -- Return the number of sections
		return 1
	}
	
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		//#warning Incomplete method implementation -- Return the number of items in the section
		return locations.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		var cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellReuseIdentifier, forIndexPath: indexPath) as LocationCollectionViewCell
		
		var number = cardNumbers[indexPath.row]
		var hue: CGFloat = CGFloat(number) / 10.0
		
		var location = locations[indexPath.row]
		var name = location["name"] as String
		var snippet = location["snippetText"] as String
		var loc = location["location"] as NSDictionary
		var coord = loc["coordinate"] as NSDictionary
		var lat = coord["latitude"] as CLLocationDegrees
		var lon = coord["longitude"] as CLLocationDegrees
		var imageURL = location["imageURL"] as String
		
		cell.titleLabel.text = name
		
		cell.descriptionLabel.text = snippet;
		
		cell.mapView.setRegion(region, animated: false);

		if cell.mapView.annotations.count > 0 {
			cell.mapView.removeAnnotations(cell.mapView.annotations)
		}
		
		let annotation: MKPointAnnotation = MKPointAnnotation()
		currentAnnotation = annotation
		currentCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
		annotation.coordinate = currentCoordinate
		annotation.title = name
		currentLocationName = name
		
		cell.mapView.delegate = self
		cell.mapView.addAnnotations(selectedAnnotations)
		cell.mapView.addAnnotation(annotation)
		
		cell.photoImageView.setImageWithURL(NSURL(string: imageURL))
		
		return cell
	}
	
	func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
		if (annotation is MKUserLocation) {
			return nil
		} else if annotation.title == AddedTitle {
			var pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
			pinView.pinColor = MKPinAnnotationColor.Green
			
			return pinView
		} else {
			return nil
		}
	}
	
	func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
		if gestureRecognizer != cardPanRecognizer {
			return true
		} else {
			var translation = cardPanRecognizer.translationInView(collectionView)
			
			// return true if the gesture is mostly horizontal, so the scrolling still works
			return fabs(translation.y) > fabs(translation.x)
		}
	}
	
	
	
	@IBAction func onCardPan(recognizer: UIPanGestureRecognizer) {
		if recognizer.state == UIGestureRecognizerState.Began {
			var panStartPoint = recognizer.locationInView(collectionView)
			currentIndexPath = collectionView.indexPathForItemAtPoint(panStartPoint)
			
			currentCard = collectionView.cellForItemAtIndexPath(currentIndexPath!) as LocationCollectionViewCell
			originalCenter = currentCard.center
		} else if recognizer.state == UIGestureRecognizerState.Changed {
			currentCard.center.y = originalCenter.y + recognizer.translationInView(collectionView).y
		} else if recognizer.state == UIGestureRecognizerState.Ended {
			//			var attr = collectionView.collectionViewLayout.finalLayoutAttributesForDisappearingItemAtIndexPath(currentIndexPath)
			//			attr?.center.y = -568
			println(recognizer.velocityInView(view))
			
			var velocity = recognizer.velocityInView(view).y
			
			if recognizer.translationInView(collectionView).y < -200 || velocity < -500 {
				velocity = max(fabs(velocity), 500.0)
				var duration = NSTimeInterval(CGFloat(568.0) / CGFloat(velocity))
				println(duration)
				
				currentAnnotation.title = AddedTitle
				selectedAnnotations.append(currentAnnotation)
				
				UIView.animateWithDuration(duration, animations: { () -> Void in
					self.currentCard.frame.origin.y = -568
					self.currentCard.alpha = 0
					
					}, completion: { (done: Bool) -> Void in
						self.currentCard.hidden = true
						self.locations.removeAtIndex(self.currentIndexPath.row)
						self.collectionView.deleteItemsAtIndexPaths([self.currentIndexPath])
						self.selectedLocationCount++
						self.updateDashboard()
						
						delay(0.5, { () -> () in
							self.currentCard.hidden = false
						})
				})
			} else {
				UIView.animateWithDuration(0.35, animations: { () -> Void in
					self.currentCard.center.y = self.originalCenter.y
				})
			}
		}
	}
	
	@IBAction func onDoneButtonTap(sender: AnyObject) {
		performSegueWithIdentifier("routePushSegue", sender: self);
	}
}
