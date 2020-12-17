//
//  ProfileViewController.swift
//  Helping Hands
//
//  Created by Javed Multani on 26/06/2020.
//  Copyright © 2020 iOS developement. All rights reserved.
//


import UIKit
import DropDown
import SwiftIcons
import MessageUI
import Realm
import RealmSwift
import CoreData


class ProfileViewController: BaseVC {
    @IBOutlet weak var catImage: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var mobileTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    let userTypeArray = ["Job Provider","Job Seeker"]


    var obj:RObjUser?
    
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
                                            title: "Profile")
    
        self.getUser()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden (true, animated: true)
        
        
    }
    
    func getUser(){
        let realm = try! Realm()
        let email = HelperFunction.helper.FetchFromUserDefault(name: "email")
               let arrayData = realm.objects(RObjUser.self).filter("email == %d",email)
               if arrayData.count>0{
                let obj:RObjUser = arrayData[0] as! RObjUser
                self.obj = obj
                self.emailTextField.text = obj.email
                //self.passwordTextField.text = obj.password
                self.mobileTextField.text = String(obj.mobileNum)
                self.firstNameTextField.text = obj.firstName
                self.lastNameTextField.text = obj.lastName
             
                
               }else{
                
        }
    }
  
    @IBAction func updateButtonHandler(_ sender: Any) {
        
        if self.emailTextField.text == "" || self.mobileTextField.text == ""{
            showAlertWithTitleWithMessage(message: "Please complete the form")
        }else{
            if HelperFunction.helper.isValidEmail(testStr: self.emailTextField.text!){
                    
                    if (self.mobileTextField.text?.length)! > 7 && (self.mobileTextField.text?.length)! < 11{
                        
                        
                         self.profileUpdate()
                        
                    }else{
                        showAlertWithTitleWithMessage(message: "Please enter valid mobile number.(Mobile number should be 8-10 digits only)")
                    }
               
                
            }else{
                showAlertWithTitleWithMessage(message: "Email is not valid")
            }
        }
    }
    func profileUpdate(){
        runOnAfterTime(afterTime: 0.1) {
        DBManager.sharedInstance.deleteObject(self.obj!)
        }
        let user = RObjUser()
              user.firstName = self.firstNameTextField.text!
              user.lastName = self.lastNameTextField.text!
              user.email = self.emailTextField.text!
             user.password = self.obj?.password!
             user.type = self.obj?.type!
              // user.gender = self.selectedGender
              user.mobileNum = Int(self.mobileTextField.text!)!
              let realm = try! Realm()
            //  let arrayData = realm.objects(RObjUser.self).filter("email == %d",self.emailTextField.text!)
//              if arrayData.count>0{
//                  showAlertWithTitleWithMessage(message: "Email already exists")
//              }else{
                  runOnAfterTime(afterTime: 1.5) {
                      DBManager.sharedInstance.addObject(object: user)
                    //DBManager.sharedInstance.addObject(object: user, update: true)
                     customeSimpleAlertView(title: "Updated!", message: "Your Profile updated successfully")
//                     let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileSuccessViewController") as? ProfileSuccessViewController
//
//                                  self.navigationController?.pushViewController(vc!, animated: true)
                      
                  }
                  
             // }
    }
    
    
}
