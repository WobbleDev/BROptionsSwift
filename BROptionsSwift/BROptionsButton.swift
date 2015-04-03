//
//  BROptionsButton.swift
//  BROptionsSwift
//
//  Created by Irlanco on 3/18/15.
//  Copyright (c) 2015 BROptions. All rights reserved.
//

import UiKit
import Foundation

enum BROptionsButtonState {
    case BROptionsButtonStateOpened  // after clicking the button, will be in open state
    case BROptionsButtonStateClosed
    case BROptionsButtonStateNormal   // it is undefined state usually closed
}

class BROptionsButton: UIButton {
    
    /*
    enum BROptionsButtonState {
        case BROptionsButtonStateOpened  // after clicking the button, will be in open state
        case BROptionsButtonStateClosed
        case BROptionsButtonStateNormal   // it is undefined state usually closed
    }
    */
    
    var dynamicsAnimator2 : UIDynamicAnimator?
    var dynamicsAnimator : UIDynamicAnimator?
    var attachmentBehavior : UIAttachmentBehavior?
    var gravityBehavior : UIGravityBehavior?
    var collisionBehavior : UICollisionBehavior?
    var dynamicItem : UIDynamicItemBehavior?
    var openedStateImage : UIImageView?
    var closedStateImage : UIImageView?
    var items : NSMutableArray
    var blackView : UIView
    
    var tabBar : UITabBar
    var locationIndexInTabBar : Int
    var delegate : MainTabBarController
    var currentState : BROptionsButtonState
    var damping : CGFloat
    var frequency : CGFloat

    
    //func initWithTabBar(tabBar : UITabBar, forItemIndex : NSUInteger, delegate : id) -> instancetype {
    //init(initWithIndex index:NSInteger) {
    init(initWithTabBar tabBarz : UITabBar, forItemIndex : Int, delegatez : MainTabBarController?) {
    
        delegate = delegatez!
        tabBar = tabBarz
        locationIndexInTabBar = forItemIndex
        damping = 0.5
        frequency = 4
        currentState = BROptionsButtonState.BROptionsButtonStateNormal
        items = NSMutableArray()
    
        super.init()
        
        self.installTheButton()
        self.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin |
            UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin;
        //self.translatesAutoresizingMaskIntoConstraints = true;
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func installTheButton() {
        var reason = "The selected index \(self.locationIndexInTabBar) is out of bounds for tabBar.items = \(self.tabBar.items?.count)"
        
        //NSAssert((self.tabBar.items.count - 1 >= self.locationIndexInTabBar), reason);
        
        if(self.tabBar.items?.count > self.locationIndexInTabBar) {
            
            var item = self.tabBar.items?[self.locationIndexInTabBar] as UITabBarItem
            item.enabled = false
            var pointToSuperview = self.buttonLocationForIndex(self.locationIndexInTabBar)
            var myRect = CGRectMake(pointToSuperview.x, pointToSuperview.y, 60, 60);
            self.frame = myRect;
            self.center = pointToSuperview;
            // self.layer.anchorPoint = CGPointMake(1, 1);
            self.backgroundColor = UIColor.blackColor()
            self.layer.cornerRadius = 6;
            self.clipsToBounds = true;
            self.tabBar.addSubview(self);
            self.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
            
            // Dynamic stuff
            //self.gravityBehavior = [[UIGravityBehavior alloc] init];
            //self.gravityBehavior.gravityDirection = CGVectorMake(0.0, -20);
            self.dynamicsAnimator = UIDynamicAnimator(referenceView:self.tabBar);
            self.dynamicItem = UIDynamicItemBehavior()
            self.dynamicItem?.allowsRotation = false;
            
            //self.collisionBehavior = [[UICollisionBehavior alloc] init];
            //self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
            //[self.dynamicsAnimator addBehavior:self.collisionBehavior];
            //[self.dynamicsAnimator addBehavior:self.gravityBehavior];
            self.tabBar.addObserver(self, forKeyPath:"selectedItem", options:NSKeyValueObservingOptions.Old | NSKeyValueObservingOptions.New, context:nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        }

    }
    
    func buttonLocationForIndex(index:Int) -> CGPoint {
        var item = self.tabBar.items?[index] as UITabBarItem
        var view = item.valueForKey("view") as UIView
        var pointToSuperview = self.tabBar.convertPoint(view.center, fromView:self.tabBar)
        return pointToSuperview;
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if(keyPath == "selectedItem") {
            if(self.currentState == BROptionsButtonState.BROptionsButtonStateOpened) {
                self.buttonPressed()
            }
        }

    }
    
    func orientationChanged() {
        if(self.currentState == BROptionsButtonState.BROptionsButtonStateOpened) {
            self.buttonPressed()
        }
    }
    
    func setImage(image:UIImage, state:BROptionsButtonState) {
        var imgV = UIImageView(frame: CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height - 20))
        imgV.image = image
        imgV.contentMode = .ScaleAspectFit
        imgV.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
    
        if(state == BROptionsButtonState.BROptionsButtonStateClosed || state == BROptionsButtonState.BROptionsButtonStateNormal) {
            self.openedStateImage = imgV;
            self.addSubview(self.openedStateImage!);
        } else {
            self.closedStateImage = imgV;
            self.closedStateImage.center = CGPointMake(self.closedStateImage.center.x,
            self.frame.size.height + (self.closedStateImage.frame.size.height/2))
            self.addSubview(self.closedStateImage!)
        }
    
    }
    
    func setLocationIndexInTabBar(newIndex:Int, animated:Bool) {
        var item1 = self.tabBar.items?[locationIndexInTabBar] as UITabBarItem
        var item2 = self.tabBar.items?[newIndex] as UITabBarItem
        item1.enabled = true
        item2.enabled = false

    
        locationIndexInTabBar = newIndex;
        var location = self.buttonLocationForIndex(newIndex)
        var frame = self.frame
        frame.origin = location;
        if(self.currentState == BROptionsButtonState.BROptionsButtonStateOpened) {
            self.buttonPressed()
        }
        if(animated) {
            UIView.animateWithDuration(0.1, animations:{
                //[self.superview layoutIfNeeded];
                //[self.superview setNeedsDisplay];
                self.center = location
                }, completion:nil)
        } else {
            self.center = location
        }
    }
    
    func buttonPressed() {
    
        if(self.currentState == BROptionsButtonState.BROptionsButtonStateNormal || self.currentState == BROptionsButtonState.BROptionsButtonStateClosed) {
            currentState = BROptionsButtonState.BROptionsButtonStateOpened;
            self.changeTheButtonStateAnimatedToOpen(true)
            //self.performSelector("showOptions:", withObject: nil, afterDelay: 0.05)
            var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("showOptions"), userInfo: nil, repeats: false)
        } else {
            currentState = BROptionsButtonState.BROptionsButtonStateClosed;
            self.hideButtons()
            var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("changeTheButtonStateAnimatedToOpen"), userInfo: nil, repeats: false)
        }
    }
    
    func changeTheButtonStateAnimatedToOpen(open:NSNumber) {
    
        var openImgCenter = self.openedStateImage.center
        var closedImgCenter = self.closedStateImage.center
    
        if(open.boolValue) {
            openImgCenter.y = ((self.openedStateImage.frame.size.height/2) * -1)
            closedImgCenter.y = self.frame.size.height/2
            closedImgCenter.x = self.frame.size.width/2
            self.addBlackView()
        } else {
            openImgCenter.y = self.frame.size.height/2
            closedImgCenter.y = self.frame.size.height + self.closedStateImage.frame.size.height/2
            self.removeBlackView()
        }
    
        self.openedStateImage.center = CGPointMake(self.frame.size.width/2, self.openedStateImage.center.y);
        self.closedStateImage.center = CGPointMake((self.frame.size.width/2) , self.closedStateImage.center.y);
    
        self.dynamicsAnimator2 = UIDynamicAnimator(referenceView:self)
    
        var snapBehaviour = UISnapBehavior(item:self.closedStateImage, snapToPoint:closedImgCenter)
        var snapBehaviour2 = UISnapBehavior(item:self.openedStateImage, snapToPoint:openImgCenter)
        snapBehaviour.damping = 0.78;
        snapBehaviour2.damping = 0.78;
        self.dynamicsAnimator2?.addBehavior(snapBehaviour)
        self.dynamicsAnimator2?.addBehavior(snapBehaviour2)
    }
    
    func addBlackView() {
    
        self.enabled = false;
        self.blackView = UIView(frame:self.tabBar.bounds)
        self.blackView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin |
            UIViewAutoresizing.FlexibleRightMargin |
            UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight |
            UIViewAutoresizing.FlexibleTopMargin |
            UIViewAutoresizing.FlexibleBottomMargin
        self.blackView.setTranslatesAutoresizingMaskIntoConstraints(true)
    
        self.blackView.backgroundColor = UIColor.blackColor()
        self.blackView.alpha = 0.0;
        var tap = UITapGestureRecognizer(target:self, action:"blackViewPressed")
        self.blackView.addGestureRecognizer(tap)
    
        
        self.tabBar.insertSubview(self.blackView, belowSubview: self.tabBar)
        UIView.animateWithDuration(0.3, animations:{
                self.blackView.alpha = 0.7;
            }, completion:{
             (finished: Bool) in //Fix me
                if(finished){
                    self.enabled = true;
                }
        });
    }

    func removeBlackView() {
    
    self.enabled = false;
    UIView.animateWithDuration(0.3, animations:{
        self.blackView.alpha = 0.0
    }, completion:
        {
            (finished: Bool) in
            if(finished) {
                self.blackView.removeFromSuperview()
                //self.blackView = nil; //CHECK
                self.enabled = false;
            }
        });
    }

    func blackViewPressed() {
        self.buttonPressed()
    }
    
    func showOptions() {
    
        var numberOfItems = self.delegate.brOptionsButtonNumberOfItems(self)
        //NSAssert(numberOfItems > 0 , "number of items should be more than 0")
    
        var angle = 0.0
        var radius:Int = 20 * numberOfItems
        angle = (180.0 / Double(numberOfItems))
        // convert to radians
    
        angle = angle/180.0 * M_PI
    
        for(var i = 0; i<numberOfItems; i++) {
            var csCalc = Float((angle * Double(i)) + (angle/2))
            var buttonX = Float(radius) * cosf(csCalc)
            var buttonY = Float(radius) * sinf(csCalc)
            var wut = (angle * Double(i)) + (angle/2)
    
            var brOptionItem = self.createButtonItemAtIndex(i)
            var mypoint = self.tabBar.convertPoint(self.center, fromView:self.superview) //Check
            var x = mypoint.x + CGFloat(buttonX)
            var y = self.frame.origin.y - CGFloat(buttonY)
            var buttonPoint = CGPointMake(x, y)
    
            brOptionItem.layer.anchorPoint = self.layer.anchorPoint
            brOptionItem.center = mypoint
    
            var attachment = UIAttachmentBehavior(item:brOptionItem, attachedToAnchor:buttonPoint)
            attachment.damping = self.damping
            attachment.frequency = self.frequency
            attachment.length = 1
        
            // set the attachment for dragging behavior
            brOptionItem.attachment = attachment
            self.dynamicItem.addItem(brOptionItem)
        
            //if([self.delegate respondsToSelector:@selector(brOptionsButton:willDisplayButtonItem:)]) {
            //    [self.delegate brOptionsButton:self willDisplayButtonItem:brOptionItem];
            //}
                
            if(self.delegate.respondsToSelector("willDisplayButtonItem:")) { //Fix me
                self.delegate.brOptionsButton(self, willDisplayButtonItem:brOptionItem)
            }
        
            self.tabBar.insertSubview(brOptionItem, belowSubview: self.tabBar)

            self.dynamicsAnimator.addBehavior(attachment)
            self.items.addObject(brOptionItem)
        }
    }
    
    /*! Just make new button, set the index
    * and customise it
    */
    func createButtonItemAtIndex(indexz:NSInteger) -> BROptionsItem {
    
        var brOptionItem = BROptionsItem(initWithIndex:indexz)
        brOptionItem.addTarget(self, action:"buttonItemPressed:", forControlEvents:.TouchUpInside)
        brOptionItem.autoresizingMask = UIViewAutoresizing.None
        
    //  if([self.delegate respondsToSelector:@selector(brOptionsButton:imageForItemAtIndex:)]) { //FIX ME
        if(self.delegate.respondsToSelector("imageForItemAtIndex:")) { //FIX ME
            var image = self.delegate.brOptionsButton(self, imageForItemAtIndex:indexz)
            if((image) != nil) {
                brOptionItem.setImage(image, forState: UIControlState.Normal)
            }
        }
        
        if(self.delegate.respondsToSelector("titleForItemAtIndex:")) { //FIX ME
            var buttonTitle = self.delegate.brOptionsButton(self, titleForItemAtIndex:indexz)
            if(buttonTitle.utf16Count > 0) {
                brOptionItem.setTitle(buttonTitle, forState:UIControlState.Normal)
            }
        }
        return brOptionItem;
    }
    
    func hideButtons() {
    
        self.dynamicsAnimator.removeAllBehaviors()
        
        dispatch_async(dispatch_get_main_queue(), {
        
            var count = 0;
            UIView.animateWithDuration(0.2, animations:{
        
                for(var i = 0; i<self.items.count; i++) {
                    var item = self.items[i] as UIView
                    item.center = self.tabBar.convertPoint(self.center, fromView:self.superview)
                    count++
                }
            }, completion: {
                (finished: Bool) in
                if(finished && count >= self.items.count) {
                    dispatch_barrier_async(dispatch_get_main_queue(), {
                        self.removeItems()
                    })
                }
            })
        })
    }
    
    func removeItems() {
        for(var i = 0; i < self.items.count; i++)
        {
            var view = self.items[i] as UIView
            view.removeFromSuperview()
        }
        
        self.items.removeAllObjects()
    }
    
    func buttonItemPressed(button:BROptionsItem) {
        
        // removing the object will not animate it with others
        self.items.removeObject(button)
        self.dynamicsAnimator.removeBehavior(button.attachment)
        self.buttonPressed()
        
        self.delegate.brOptionsButton(self, didSelectItem:button)
        
        UIView.animateWithDuration(0.3, animations:{
            self.layoutIfNeeded()
            button.transform = CGAffineTransformMakeScale(5, 5)
            button.alpha  = 0.0
            button.center = CGPointMake(button.frame.size.width/2 + button.frame.size.width/2, button.frame.size.height/2)
        }, completion:{
            (finished: Bool) in
            if(finished) {
                button.removeFromSuperview()
            }
        })
    }


}
