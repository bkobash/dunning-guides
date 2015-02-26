//
//  NewGuideViewController.swift
//  Guide
//
//  Created by Nathalie Kowalczyk on 2/23/15.
//  Copyright (c) 2015 Nathalie. All rights reserved.
//

import UIKit

class StartingPointViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBarHidden = true;
    }
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nearbyReccomendations: UIImageView!
    @IBOutlet weak var selectStartingPoint: UIImageView!
    @IBOutlet weak var tagTacos: UIButton!
    @IBOutlet weak var tagValencia: UIButton!
    @IBOutlet weak var tagBurrito: UIButton!
    @IBOutlet weak var tagPubs: UIButton!
    @IBOutlet weak var tagMission: UIButton!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        textField.becomeFirstResponder()
        textField.delegate = self
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.nearbyReccomendations.alpha = 1
        })
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.selectStartingPoint.alpha = 0.5
        })
        view.endEditing(true)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.tagTacos.alpha = 1
            self.tagValencia.alpha = 1
            self.tagBurrito.alpha = 1
            self.tagPubs.alpha = 1
            self.tagMission.alpha = 1
        })
        
        return true
        
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
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.nearbyReccomendations.alpha = 1
        })
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.selectStartingPoint.alpha = 0.5
        })
        view.endEditing(true)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.tagTacos.alpha = 1
            self.tagValencia.alpha = 1
            self.tagBurrito.alpha = 1
            self.tagPubs.alpha = 1
            self.tagMission.alpha = 1
        })
    }
    
    @IBAction func onTapSelect(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.nearbyReccomendations.alpha = 0.5
        })
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.selectStartingPoint.alpha = 1
        })
        view.endEditing(true)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.tagTacos.alpha = 0.5
            self.tagValencia.alpha = 0.5
            self.tagBurrito.alpha = 0.5
            self.tagPubs.alpha = 0.5
            self.tagMission.alpha = 0.5
        })
        
    }
    
    @IBAction func didPressTagTacosButton(sender: AnyObject) {
        tagTacos.selected = true
    }
    
    @IBAction func didPressCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressTagValenciaButton(sender: AnyObject) {
        tagValencia.selected = true
    }
    
    @IBAction func didPressTagBurritoButton(sender: AnyObject) {
        tagBurrito.selected = true
    }
    
    @IBAction func didPressTagPubs(sender: AnyObject) {
        tagPubs.selected = true
        
    }
    
    @IBAction func didPressTagMissionButton(sender: AnyObject) {
        tagMission.selected = true
        
    }
    
    @IBAction func didPressStartButton(sender: AnyObject) {
        performSegueWithIdentifier("cardPushSegue", sender: self);
    }
}
