//
//  aboutUsViewController.swift
//  Helping Hands
//
//  Created by Javed Multani on 26/06/2020.
//  Copyright © 2020 iOS developement. All rights reserved.
//
import SwiftIcons
import UIKit

class aboutUsViewController: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
             super.viewWillAppear(true)
                self.navigationController?.setNavigationBarHidden (false, animated: false)
               self.setNavigationbarleft_imagename(left_icon_Name: IoniconsType.androidArrowBack, left_action: #selector(self.btnBackHandle(_:)),
                                                           right_icon_Name:nil,
                                                           right_action: nil,
                                                           title: "About Us")
            
         }

     override func viewWillDisappear(_ animated: Bool) {
              super.viewWillDisappear(true)
                 self.navigationController?.setNavigationBarHidden (true, animated: true)
               
             
          }
    

}
