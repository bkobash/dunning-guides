//
//  LocationCollectionViewCell.swift
//  swipe-test
//
//  Created by yahoo on 2/21/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
/*
	@IBAction func onCardPan(recognizer: UIPanGestureRecognizer) {
		if recognizer.state == UIGestureRecognizerState.Began {
			originalCenter = center
		} else if recognizer.state == UIGestureRecognizerState.Changed {
			center.x = recognizer.translationInView(self).x
		}
	}
*/
}
