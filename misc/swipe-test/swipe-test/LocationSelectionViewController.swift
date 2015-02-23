//
//  LocationSelectionViewController.swift
//  swipe-test
//
//  Created by yahoo on 2/21/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

import UIKit

class LocationSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
	
	let CellReuseIdentifier = "LocationCollectionViewCell"
	
	var originalCenter: CGPoint!
	var currentCard: LocationCollectionViewCell!
	var currentIndexPath: NSIndexPath!
	var cardCount = 10
	var cardNumbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
	
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet var cardPanRecognizer: UIPanGestureRecognizer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var nib = UINib(nibName: "LocationCollectionViewCell", bundle: nil)
		
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.registerNib(nib, forCellWithReuseIdentifier: CellReuseIdentifier)
		
		cardPanRecognizer.delegate = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		//#warning Incomplete method implementation -- Return the number of sections
		return 1
	}
	
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		//#warning Incomplete method implementation -- Return the number of items in the section
		return cardNumbers.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		var cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellReuseIdentifier, forIndexPath: indexPath) as LocationCollectionViewCell
		
		var number = cardNumbers[indexPath.row]
		var hue: CGFloat = CGFloat(number) / 10.0
		
		cell.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
		cell.nameLabel.text = "\(number)"
		
		return cell
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
			if fabs(recognizer.translationInView(collectionView).y) > 200 {
				UIView.animateWithDuration(0.35, animations: { () -> Void in
					self.currentCard.frame.origin.y = -568
					}, completion: { (done: Bool) -> Void in
						//					self.currentCard.hidden = true
						self.cardCount--
						self.cardNumbers.removeAtIndex(self.currentIndexPath.row)
						self.collectionView.deleteItemsAtIndexPaths([self.currentIndexPath])
				})
			} else {
				UIView.animateWithDuration(0.35, animations: { () -> Void in
					self.currentCard.center.y = self.originalCenter.y
				})
			}
		}
	}
}
