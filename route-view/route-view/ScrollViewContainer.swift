//
//  ScrollViewContainer.swift
//  route-view
//
//  Created by Brian Kobashikawa on 2/23/15.
//  Copyright (c) 2015 Brian Kobashikawa. All rights reserved.
//

import UIKit

class ScrollViewContainer: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let view: UIView! = super.hitTest(point, withEvent: event);
        if (view == self) {
            return scrollView;
        } else {
            return view;
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
