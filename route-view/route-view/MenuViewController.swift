//
//  MenuViewController.swift
//  route-view
//
//  Created by Brian Kobashikawa on 2/23/15.
//  Copyright (c) 2015 Brian Kobashikawa. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBarHidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "previewRouteSegue") {
            let routeViewController = segue.destinationViewController as RouteViewController;
            routeViewController.isPreviewMode = true;
        }
    }


}
