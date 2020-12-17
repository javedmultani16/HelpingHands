//
//  SettingsViewController.swift
//  Helping Hands
//
//  Created by Javed Multani on 26/06/2020.
//  Copyright © 2020 iOS developement. All rights reserved.
//

import UIKit
import SwiftIcons

class SettingsViewController: BaseVC {

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
                                                           title: "Settings")
            
         }

     override func viewWillDisappear(_ animated: Bool) {
              super.viewWillDisappear(true)
                 self.navigationController?.setNavigationBarHidden (true, animated: true)
               
             
          }
    
    @IBAction func logoutHandler(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func profileHandler(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
                  self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func aboutUsHandler(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "aboutUsViewController") as? aboutUsViewController
                  self.navigationController?.pushViewController(vc!, animated: true)
        
    }
}
