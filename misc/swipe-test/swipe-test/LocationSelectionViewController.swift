//
//  LocationSelectionViewController.swift
//  swipe-test
//
//  Created by yahoo on 2/21/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

import UIKit

class LocationSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	
	let CellReuseIdentifier = "LocationCollectionViewCell"
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		var nib = UINib(nibName: "LocationCollectionViewCell", bundle: nil)
		
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.registerNib(nib, forCellWithReuseIdentifier: CellReuseIdentifier)
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
		return 10
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

		var cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellReuseIdentifier, forIndexPath: indexPath) as LocationCollectionViewCell
		
		var hue: CGFloat = CGFloat(indexPath.row) / 10.0
		
		cell.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
		cell.nameLabel.text = "\(indexPath.row)"
		
		return cell
	}
}
