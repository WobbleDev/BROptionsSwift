//
//  SecondViewController.swift
//  BROptionsSwift
//
//  Created by Irlanco on 3/17/15.
//  Copyright (c) 2015 BROptions. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var locationTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationTextField?.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeLocationPressed(sender: AnyObject) {
        self.locationTextField?.resignFirstResponder()
        var index = self.locationTextField?.text.toInt()
        
        self.commonDelegate.changeBROptionsButtonLocationTo(index, animated:true)
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        self.locationTextField?.resignFirstResponder()
        return true
    }


}

