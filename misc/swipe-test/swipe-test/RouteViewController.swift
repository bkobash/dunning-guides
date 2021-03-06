//
//  RouteViewController.swift
//  route-view
//
//  Created by Brian Kobashikawa on 2/23/15.
//  Copyright (c) 2015 Brian Kobashikawa. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapScrollView: UIScrollView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var mapRouteImageView: UIImageView!
    
    @IBOutlet weak var pinContainerView: UIView!
    @IBOutlet weak var mapOverlayView: UIView!
    
    @IBOutlet weak var pinCurrentImageView: UIImageView!
    
    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet weak var cardScrollView: UIScrollView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var ctaButton: UIButton!
    
    var isPreviewMode: Bool = true;
    
    var cards: [String] = [];
    var cardOffsets: [CGPoint] = [];
    
    var cardImages: [UIImageView] = [];
    var cardNumbers: [UIImageView] = [];
    var cardNumbersFilled: [UIImageView] = [];
    var pinButtons: [UIButton] = [];
    var pinOverlayButtons: [UIButton] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        mapScrollView.contentSize = mapImageView.frame.size;
        mapView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: mapImageView.frame.size);
        mapImageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: mapImageView.frame.size);
        pinContainerView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: mapImageView.frame.size);
        mapScrollView.minimumZoomScale = 0.75;
        mapScrollView.maximumZoomScale = 4.0;
        mapScrollView.delegate = self;
        
        cardScrollView.delegate = self;
        
        self.cards = [
            "mini-card-farolito",
            "mini-card-papalote",
            "mini-card-lataqueria",
            "mini-card-precita",
            "mini-card-roosevelt",
            "mini-card-addanother"
        ];
        self.cardOffsets = [
            CGPoint(x: 471, y: 682),
            CGPoint(x: 361, y: 704),
            CGPoint(x: 477, y: 759),
            CGPoint(x: 727, y: 682),
            CGPoint(x: 832, y: 675)
        ];
        
        pinCurrentImageView.center = CGPoint(x: 449, y: 461);
        mapRouteImageView.frame = CGRect(origin: CGPoint(x: 300, y: 400), size: mapRouteImageView.frame.size);
        createCards();
        createPins();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.cardContainerView.center = CGPoint(x: 480, y: 460);
        if (isPreviewMode) {
            self.backButton.hidden = false;
            self.closeButton.hidden = true;
            ctaButton.setTitle("Save", forState: UIControlState.Normal);
            ctaButton.setTitle("Save", forState: UIControlState.Selected);
        } else {
            self.backButton.hidden = true;
            self.closeButton.hidden = false;
            ctaButton.setTitle("Start", forState: UIControlState.Normal);
            ctaButton.setTitle("Start", forState: UIControlState.Selected);
        }
    }
    override func viewDidAppear(animated: Bool) {
        animateToPin(-1);
        
        UIView.animateWithDuration(1, delay: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: nil, animations: { () -> Void in
            self.cardContainerView.center = CGPoint(x: 160, y: 460);
            }, completion: nil);
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func createCards() {
        
        let cardWidth: Int = 245;
        var cardView: UIView,
        cardImageView: UIImageView,
        cardTapGestureRecognizer: UITapGestureRecognizer,
        cardNumberImageView: UIImageView,
        cardNumberFilledImageView: UIImageView,
        cardNumberImageName: String,
        cardNumberFilledImageName: String,
        cardOffsetX: Int;
        
        for var i: Int = 0; i < self.cards.count; i++ {
            
            cardOffsetX = (i * cardWidth);
            cardView = UIView(frame: CGRect(x: cardOffsetX, y: 0, width: cardWidth, height: 80));
            
            cardImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cardWidth, height: 80));
            cardImageView.image = UIImage(named: cards[i] as String);
            cardImageView.userInteractionEnabled = true;
            
            cardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onCardTap:");
            cardTapGestureRecognizer.delegate = self;
            cardImageView.addGestureRecognizer(cardTapGestureRecognizer);
            
            cardImages.append(cardImageView);
            
            cardView.addSubview(cardImages[i]);
            
            // These cards include the "Add another destination" card at the end.
            // That card doesn't have a set of number images tied to it.
            if (i < self.cards.count - 1) {
                cardNumberImageName = "num-" + String(i + 1);
                cardNumberImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 40, height: 40));
                cardNumberImageView.image = UIImage(named: cardNumberImageName);
                cardNumbers.append(cardNumberImageView);
                
                cardNumberFilledImageName = "num-" + String(i + 1) + "-fill";
                cardNumberFilledImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 40, height: 40));
                cardNumberFilledImageView.image = UIImage(named: cardNumberFilledImageName);
                cardNumberFilledImageView.alpha = (i == 0) ? 1 : 0;
                cardNumbersFilled.append(cardNumberFilledImageView);
                
                cardView.addSubview(cardNumbers[i]);
                cardView.addSubview(cardNumbersFilled[i]);
            }
            
            self.cardScrollView.addSubview(cardView);
        }
        
        self.cardScrollView.contentSize = CGSize(width: cardWidth * self.cards.count, height: 60);
        self.cardScrollView.pagingEnabled = true;
        
    }
    
    func createPins() {
        
        let pinWidth: Int = 40;
        var pinButton: UIButton,
        pinOverlayButton: UIButton,
        pinOffset: CGPoint,
        pinSize: CGSize,
        pinImageName: String,
        pinFilledImageName: String;
        
        for var i: Int = 0; i < self.cardOffsets.count; i++ {
            
            pinOffset = CGPoint(x: self.cardOffsets[i].x - CGFloat(pinWidth / 2), y: self.cardOffsets[i].y - CGFloat(pinWidth / 2));
            pinSize = CGSize(width: pinWidth, height: pinWidth);
            pinImageName = "num-" + String (i + 1);
            pinFilledImageName = "num-" + String(i + 1) + "-fill";
            
            pinButton = UIButton(frame: CGRect(origin: pinOffset, size: pinSize)) as UIButton;
            pinButton.setImage(UIImage(named: pinImageName), forState: UIControlState.Normal);
            pinButton.setImage(UIImage(named: pinFilledImageName), forState: UIControlState.Selected);
            
            pinOverlayButton = UIButton(frame: CGRect(origin: pinOffset, size: pinSize)) as UIButton;
            pinOverlayButton.addTarget(self, action: "onPinTap:", forControlEvents: UIControlEvents.TouchUpInside);
            
            self.pinButtons.append(pinButton);
            self.pinOverlayButtons.append(pinOverlayButton);
            self.pinContainerView.addSubview(self.pinButtons[i]);
            self.mapScrollView.addSubview(self.pinOverlayButtons[i]);
        }
    }
    
    func animateToPin(pin: Int) {
        var offset: CGPoint = CGPoint(),
        routeImageName: String,
        zoomScale: CGFloat = self.mapScrollView.zoomScale,
        pageWidth: CGFloat = self.view.bounds.width,
        pageHeight: CGFloat = self.view.bounds.height;
        
        // Make sure we're omitting the last card
        if (pin < self.cardOffsets.count) {
            
            if (pin == -1) {
                // User's starting point
                offset.x = (449 * zoomScale) - (pageWidth / 2);
                offset.y = (601 * zoomScale) - (pageHeight / 2);
            } else {
                // Center the screen around the destination point
                offset.x = (self.cardOffsets[pin].x * zoomScale) - (pageWidth / 2);
                offset.y = (self.cardOffsets[pin].y * zoomScale) - (pageHeight / 2);
            }
            
            // Fade in/out the number image
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                var cardNumberFilledImageView: UIImageView;
                self.mapScrollView.contentOffset = offset;
                for var i: Int = 0; i < self.cardNumbersFilled.count; i++ {
                    cardNumberFilledImageView = self.cardNumbersFilled[i] as UIImageView;
                    cardNumberFilledImageView.alpha = (pin == i) ? 1 : 0;
                }
            });
            
            // Highlight the marker on the map
            for var i: Int = 0; i < self.cardOffsets.count; i++ {
                self.pinButtons[i].selected = false;
            }
            
            // Swap out the route image
            if (pin > -1) {
                self.pinButtons[pin].selected = true;
                routeImageName = "map-route-" + String(pin + 1);
                self.mapRouteImageView.image = UIImage(named: routeImageName);
            }
        }
    }
    
    func onCardTap(sender:UITapGestureRecognizer!) {
        
        // If the user taps directly on a card, go to that card's destination.
        // Really only applies to the first card.
        for var i: Int = 0; i < self.cards.count; i++ {
            if (self.cardImages[i] == sender.view) {
                if (i == self.cards.count - 1 && self.isPreviewMode) {
                    // Last card (Add another)
                    self.navigationController?.popViewControllerAnimated(true);
                } else {
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.cardScrollView.contentOffset = CGPoint(x: 245 * i, y: 0);
                    });
                    self.animateToPin(i);
                }
                break;
            }
        }
        
    }
    
    func onPinTap(sender:UIButton!) {
        
        // If the user taps directly on a pin, recenter the pin and scroll to
        // the corresponding card.
        for var i: Int = 0; i < self.cardOffsets.count; i++ {
            if (self.pinOverlayButtons[i] == sender) {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.cardScrollView.contentOffset = CGPoint(x: 245 * i, y: 0);
                });
                self.animateToPin(i);
                break;
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // Didn't figure out how hit-testing really works. So the scrollview is on
        // the topmost layer, and controls a map image several layers underneath.
        if (scrollView == self.mapScrollView) {
            var origin = CGPoint(x: -scrollView.contentOffset.x, y: -scrollView.contentOffset.y);
            self.mapView.frame = CGRect(origin: origin, size: self.mapView.frame.size);
            self.pinContainerView.frame = CGRect(origin: origin, size: self.mapView.frame.size);
        }
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        // If the user zooms in/out, move the pins to their corresponding locations
        // in the viewport (as opposed to scaling them relative to the map).
        if (scrollView == self.mapScrollView) {
            var scale = scrollView.zoomScale,
            offset: CGPoint;
            for var i: Int = 0; i < self.cardOffsets.count; i++ {
                offset = CGPoint(x: self.cardOffsets[i].x * scale, y: self.cardOffsets[i].y * scale);
                self.pinButtons[i].center = offset;
                self.pinOverlayButtons[i].center = offset;
            }
            pinCurrentImageView.center = CGPoint(x: 449 * scale, y: 461 * scale);
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        // If the user pages through the card scrollview, highlight the respective
        // points on the map.
        if (scrollView == self.cardScrollView) {
            var page: Int = Int(floor(scrollView.contentOffset.x / 245));
            animateToPin(page);
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.mapView;
    }
    
    @IBAction func onBackButtonTap(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true);
    }
    
    @IBAction func onCloseButtonTap(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil);
    }
    
}
