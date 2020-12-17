//
//  ProfileSuccessViewController.swift
//  Helping Hands
//
//  Created by Javed Multani on 27/06/2020.
//  Copyright © 2020 iOS developement. All rights reserved.
//

import UIKit

class ProfileSuccessViewController: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBackHandler(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    

}
