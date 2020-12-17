//
//  TaskSuccessfullyAddedViewController.swift
//  Helping Hands
//
//  Created by iOS on 20/06/2020.
//  Copyright © 2020 iOS developement. All rights reserved.
//

import UIKit
import SwiftIcons

class TaskSuccessfullyAddedViewController: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
     override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
               self.navigationController?.setNavigationBarHidden (true, animated: true)
          
        }

   
    
    @IBAction func buttonhandlerBack(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CompanyHomeViewController") as? CompanyHomeViewController
                  self.navigationController?.pushViewController(vc!, animated: true)
    }
    

}
