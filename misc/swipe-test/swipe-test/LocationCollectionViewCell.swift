//
//  LocationCollectionViewCell.swift
//  swipe-test
//
//  Created by yahoo on 2/21/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

import UIKit
import MapKit

class LocationCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var titleContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
	
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var photo1ImageView: UIImageView!
    @IBOutlet weak var photo2ImageView: UIImageView!
    @IBOutlet weak var photo3ImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        var destinationString: NSString = NSString(string: titleLabel.text!);
        var destinationStringSize: CGSize = destinationString.sizeWithAttributes([ NSFontAttributeName: titleLabel.font ]);
        titleContainerView.frame.size = CGSizeMake(destinationStringSize.width + 20, 40);
    }
    
    override func prepareForReuse() {
        super.prepareForReuse();
        self.setNeedsLayout();
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
