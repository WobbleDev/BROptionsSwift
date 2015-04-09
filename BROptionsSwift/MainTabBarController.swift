//
//  MainTabBarController.swift
//  BROptionsSwift
//
//  Created by Irlanco on 3/21/15.
//  Copyright (c) 2015 BROptions. All rights reserved.
//

import UiKit

class MainTabBarController: UITabBarController,BROptionButtonDelegate,CommonDelegate { //BROptionButtonDelegate,

    var brOptionsButton:BROptionsButton?
    
    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        //var second = viewControllers[1] as SecondViewController
        
        //println("\(self.viewController?)")
        var viewControllers = self.viewControllers?
        var second = viewControllers?[1] as SecondViewController
        
        second.commonDelegate = self
        
        // Do any additional setup after loading the view.
        var brOption = BROptionsButton(initWithTabBar:self.tabBar, forItemIndex:1, delegatez:self)
        self.brOptionsButton = brOption
        brOption.setImage(UIImage(named: "Apple")!, state: BROptionsButtonState.BROptionsButtonStateNormal)
        brOption.setImage(UIImage(named: "close")!, state: BROptionsButtonState.BROptionsButtonStateOpened)

        //brOption.setImage(UIImage(named:"Apple"), forBROptionsButtonState:BROptionsButtonState.BROptionsButtonStateNormal) //CHECK
        //brOption.setImage(UIImage(named:"close"), forBROptionsButtonState:BROptionsButtonState.BROptionsButtonStateOpened)
    }

    func brOptionsButton(brOptionsButton: BROptionsButton!, didSelectItem: BROptionsItem!) {
        self.selectedIndex = brOptionsButton.locationIndexInTabBar
    }
    
    func brOptionsButtonNumberOfItems(brOptionsButton:BROptionsButton!) -> Int {
        return 3
    }
    
    func brOptionsButton(optionsButton: BROptionsButton!, willDisplayButtonItem: BROptionsItem!)
    {
        //println("WillDisplayButtonItem")
    }
    
    func brOptionsButton(brOptionsButton: BROptionsButton!, titleForItemAtIndex: Int) -> String {
        //println("TitleForItemAtIndex")
        return "None"
    }
    
    func brOptionsButton(brOptionsButton: BROptionsButton!, imageForItemAtIndex: Int) -> UIImage! {
        var image = UIImage(named: "Apple")
        return image
    }
    
    func changeBROptionsButtonLocationTo(location: Int, animated: Bool){
        if(location < self.tabBar.items?.count) {
            self.brOptionsButton!.setLocationIndexInTabBar(location, animated:true)
        } else {
            var alert = UIAlertView(title: "", message: "wrong index", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }


}
