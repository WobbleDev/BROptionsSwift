//
//  MainTabBarController.swift
//  BROptionsSwift
//
//  Created by Irlanco on 3/21/15.
//  Copyright (c) 2015 BROptions. All rights reserved.
//

import UiKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var second = self.viewControllers[1]
        second.commonDelegate = self
        
        // Do any additional setup after loading the view.
        var brOption = BROptionsButton(initWithTabBar:self.tabBar, forItemIndex:1, delegatez:self)
        self.brOptionsButton = brOption
        brOption.setImage(UIImage(named:"Apple"), forBROptionsButtonState:BROptionsButtonState.BROptionsButtonStateNormal) //CHECK
        brOption.setImage(UIImage(named:"close"), forBROptionsButtonState:BROptionsButtonState.BROptionsButtonStateOpened)
    }

    func brOptionsButtonNumberOfItems(brOptionsButton:BROptionsButton) -> NSInteger {
        return 6
    }
    
    func brOptionsButton(brOptionsButton: BROptionsButton!, imageForItemAtIndex index: Int) -> UIImage! {
        var image = UIImage(named: "Apple")
        return image
    }
    
    
    func brOptionsButton(brOptionsButton: BROptionsButton!, didSelectItem item: BROptionItem!) {
        self.setSelectedIndex(brOptionsButton.locationIndexInTabBar())
    }
    

    
    func changeBROptionsButtonLocaitonTo(location: Int, animated: Bool){
        if(location < self.tabBar.items?.count) {
            self.brOptionsButton.setLocationIndexInTabBar(location, animated:true)
        } else {
            var alert = UIAlertView(title: "", message: "wrong index", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil)
            alert.show()
        }
    }


}
