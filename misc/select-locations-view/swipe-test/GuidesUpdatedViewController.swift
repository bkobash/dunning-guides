//
//  GuidesUpdatedViewController.swift
//  swipe-test
//
//  Created by Brian Kobashikawa on 2/26/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

import UIKit

class GuidesUpdatedViewController: UIViewController {

    @IBOutlet weak var missionCardImageView: UIImageView!
    
    var justCreated: Bool! = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if justCreated == true {
            missionCardImageView.center = CGPoint(x: -160, y: 170);
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if justCreated == true {
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: nil, animations: { () -> Void in
                self.missionCardImageView.center = CGPoint(x: 87, y: 170);
                }, completion: nil);
            justCreated = false;
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "missionSegue" {
            var destinationVC = segue.destinationViewController as RouteViewController;
            destinationVC.isPreviewMode = false;
        }
    }
    

    @IBAction func onAddButtonTap(sender: AnyObject) {
        performSegueWithIdentifier("createAnotherSegue", sender: self);
    }
    @IBAction func onSelectRouteButtonTap(sender: AnyObject) {
        performSegueWithIdentifier("missionSegue", sender: self);
    }
}
