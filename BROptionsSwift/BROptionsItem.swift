//
//  BROptionsItem.swift
//  BROptionsSwift
//
//  Created by Irlanco on 3/18/15.
//  Copyright (c) 2015 BROptions. All rights reserved.
//

import UIKit
import CoreMotion

class BROptionsItem: UIButton {

    var dragAttachement : UIAttachmentBehavior?
    var dynamicsAnimator : UIDynamicAnimator?
    var collisionBehavior : UICollisionBehavior?
    
    let kBROptionsItemDefaultItemHeight:CGFloat = 40.0;
    
    var attachment:UIAttachmentBehavior?
    var index:NSInteger?
    
    init(initWithIndex indexz:NSInteger) {
        index = indexz
        super.init(frame: CGRectMake(0.0, 0.0, kBROptionsItemDefaultItemHeight, kBROptionsItemDefaultItemHeight))
        self.LayoutTheButton()
    }
    
    /*
    override init(){
        super.init(frame: CGRectMake(0.0, 0.0, kBROptionsItemDefaultItemHeight, kBROptionsItemDefaultItemHeight))
        //super.init(frame:CGRectMake(0.0, 0.0, kBROptionsItemDefaultItemHeight, kBROptionsItemDefaultItemHeight))
        self.LayoutTheButton()
        
    }
    */

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func LayoutTheButton() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.backgroundColor = UIColor.blueColor()
        
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0.0, 1)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
    }
    
    
    // overriding super class methods
    func setImage(image:UIImage, state:UIControlState) {
        super.setImage(image, forState:state)
        self.backgroundColor = UIColor.clearColor()
    }
    
    //TODO: override setCenter or setFrame
    
    func touchesBegan(touches:NSSet, event:UIEvent) {
    
        for touch: AnyObject in touches {
        //var touch = touches.anyObject()
            var location = touch.locationInView(self.superview)
            location.x += (self.frame.size.width/2);
            location.y += (self.frame.size.height/2);
            self.dragAttachement  = UIAttachmentBehavior(item:self, attachedToAnchor:location)
            self.highlighted = true
            
            var animator = self.attachment?.dynamicAnimator
            // add attachment to move
            animator?.addBehavior(self.dragAttachement)
            // remove the old behavior
            animator?.removeBehavior(self.attachment)
        }
    }
    
    func touchesMoved(touches:NSSet, event:UIEvent) {
        // move the attachment
        for touch: AnyObject in touches {
            //var touch = touches.anyObject()
            var nextPoint = touch.locationInView(self)
            nextPoint.x += (self.frame.size.width/2);
            nextPoint.y += (self.frame.size.height/2);
            
            nextPoint = self.convertPoint(nextPoint, fromView:self) //Check
            self.dragAttachement?.anchorPoint = nextPoint
            
            self.highlighted = false;
        }
    }
    
    func touchesEnded(touches:NSSet, event:UIEvent){
        // remove the attachment
        var animator = self.dragAttachement?.dynamicAnimator
        
        animator?.removeBehavior(self.dragAttachement)
        animator?.addBehavior(self.attachment)
        // add the old attachment
        
        if(self.highlighted) {
            self.sendActionsForControlEvents(.TouchUpInside)
        }
        self.highlighted = false;
    }
    
    /*
    override func dealloc() {
        attachment = nil
    }
    */

}
