//
//  GuidesViewController.swift
//  swipe-test
//
//  Created by Brian Kobashikawa on 2/26/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

import UIKit

class GuidesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: false);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onCreateButtonTap(sender: AnyObject) {
        performSegueWithIdentifier("createSegue", sender: self);
    }
}
