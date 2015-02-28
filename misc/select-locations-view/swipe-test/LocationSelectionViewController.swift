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
	var locations: [PFObject] = []
	var selectedLocationCount = 0
	
	var missionDistrictLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.76, longitude: -122.42);
	var regionSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02);
	var region: MKCoordinateRegion!
	var currentAnnotation: MKPointAnnotation!
	var currentCoordinate: CLLocationCoordinate2D!
	var currentLocationName: String!
	var selectedAnnotations: [MKPointAnnotation]! = []
	var latestLocationDate: NSDate!
	var timer: NSTimer!

	
    @IBOutlet weak var mapView: MKMapView!
    
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet var cardPanRecognizer: UIPanGestureRecognizer!
	
	@IBOutlet weak var dashboardDurationLabel: UILabel!
	@IBOutlet weak var dashboardPlacesLabel: UILabel!
	
    @IBOutlet weak var loadingView: UIView!
	
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
		
		var c = NSDateComponents()
		c.year = 2015
		c.month = 2
		c.day = 24
		
		var gregorian = NSCalendar(calendarIdentifier: NSGregorianCalendar)
		latestLocationDate = gregorian?.dateFromComponents(c)
		
		getLocations()
		updateDashboard()
		
		timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("getLocations"), userInfo: nil, repeats: true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    override func viewWillAppear(animated: Bool) {
        loadingView.hidden = false;
        loadingView.alpha = 1;
        loadingView.center = CGPoint(x: 160, y: 284);
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(0.5, delay: 2, options: nil, animations: { () -> Void in
            self.loadingView.alpha = 0;
        }) { (Bool) -> Void in
            self.loadingView.hidden = true;
        }
    }
	
	func onTimer() {
		
	}
	
	func getLocations() {
		var query = PFQuery(className: "Location")

		query.whereKey("createdAt", greaterThan: latestLocationDate)
		query.findObjectsInBackgroundWithBlock {
			(objects: [AnyObject]!, error: NSError!) -> Void in
			if error == nil {
				if objects.count > 0 {
					self.locations += objects as [PFObject]
					self.collectionView.reloadData()
					println(self.locations.count)
					self.latestLocationDate = self.locations[self.locations.count - 1].createdAt
				}
			} else {
				// Log details of the failure
				NSLog("Error: %@ %@", error, error.userInfo!)
			}
		}
	}
	
	func updateDashboard() {
		var place = "place"
		
		if selectedLocationCount > 1 || selectedLocationCount == 0 {
			place = "places"
		}
		
		dashboardDurationLabel.text = "\(selectedLocationCount * 5) min"
		dashboardPlacesLabel.text = "\(selectedLocationCount) \(place), \(selectedLocationCount * 2) mi total"
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
		
		mapView.setRegion(region, animated: false);

		if mapView.annotations.count > 0 {
			mapView.removeAnnotations(mapView.annotations)
		}
		
		let annotation: MKPointAnnotation = MKPointAnnotation()
		currentAnnotation = annotation
		currentCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
		annotation.coordinate = currentCoordinate
		annotation.title = name
		currentLocationName = name
		
		mapView.delegate = self
		mapView.addAnnotations(selectedAnnotations)
		mapView.addAnnotation(annotation)
		
		var zoomRect = MKMapRectNull
		
		for p in mapView.annotations {
			var pin = p as MKPointAnnotation
			var pinCoords = MKMapPointForCoordinate(pin.coordinate)
			var pointRect = MKMapRectMake(pinCoords.x, pinCoords.y, 0.1, 0.1)
			zoomRect = MKMapRectUnion(zoomRect, pointRect)
		}
		
		zoomRect.origin.y += 400

		mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 110, left: 40, bottom: 300, right: 40), animated: true)
		
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
				var duration = NSTimeInterval(CGFloat(400.0) / CGFloat(velocity))
				println(duration)
				
				var annotationCopy: MKPointAnnotation = MKPointAnnotation()
				annotationCopy.coordinate = currentAnnotation.coordinate
				annotationCopy.title = AddedTitle
				selectedAnnotations.append(annotationCopy)

				UIView.animateWithDuration(duration, animations: { () -> Void in
					self.currentCard.frame.origin.y = -400
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
	
    @IBAction func onCancelButtonTap(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true);
    }
	@IBAction func onDoneButtonTap(sender: AnyObject) {
		performSegueWithIdentifier("routePushSegue", sender: self);
	}
}
