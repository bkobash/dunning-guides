//
//  LoginViewController.swift
//  Guide
//
//  Created by Nathalie Kowalczyk on 2/24/15.
//  Copyright (c) 2015 Nathalie. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false);
        
        emailField.textColor = UIColor.whiteColor()
        emailField.attributedPlaceholder =  NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName : UIColor.grayColor()])
        passwordField.textColor = UIColor.whiteColor()
        passwordField.attributedPlaceholder =  NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.grayColor()])
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
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)}
    
    @IBAction func didPressLoginButton(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.loadingView.alpha = 1
        })
        
        loadingView.startAnimating()
        delay(1, { () -> () in
            if (self.emailField.text == "email@yahoo.com" && self.passwordField.text == "password") {
                self.performSegueWithIdentifier("loginSegue", sender: nil)
                self.loadingView.stopAnimating()
            } else {
                var alertView = UIAlertView (title: "Ooops", message: "Please enter a valid email", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
                self.loadingView.stopAnimating()
                
            }
        })
    }
}
