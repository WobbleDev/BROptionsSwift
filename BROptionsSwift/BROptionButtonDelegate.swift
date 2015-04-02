//
//  BROptionButtonDelegate.swift
//  BROptionsSwift
//
//  Created by Irlanco on 3/31/15.
//  Copyright (c) 2015 BROptions. All rights reserved.
//

import Foundation
import UIKit

protocol BROptionButtonDelegate {
    func brOptionsButton(brOptionsButton: BROptionsButton!, didSelectItem: BROptionsItem!)
    
    func brOptionsButtonNumberOfItems(brOptionsButton: BROptionsButton!) -> Int
    
    func brOptionsButton(optionsButton: BROptionsButton!, willDisplayButtonItem: BROptionsItem!)
    
    func brOptionsButton(brOptionsButton: BROptionsButton!, titleForItemAtIndex: Int) -> String
    
    func brOptionsButton(brOptionsButton: BROptionsButton!, imageForItemAtIndex: Int) -> UIImage!
}

protocol CommonDelegate {
    func changeBROptionsButtonLocationTo(location: Int, animated: Bool)
}
