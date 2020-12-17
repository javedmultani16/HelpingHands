//
//  SignupViewController.swift
//  App
//
//  Created by iOS on 24/07/20.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import DropDown
import SwiftIcons
import MessageUI
import Alamofire
import Realm
import RealmSwift
import CoreData


class SignupViewController: BaseVC {
    
    @IBOutlet weak var ButtonUserType: UIButton!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldMobile: UITextField!
    @IBOutlet weak var buttonGender: UIButton!
    @IBOutlet weak var buttonSignup: UIButton!
    let userTypeArray = ["Job Provider","Job Seeker"]//["Admin","Job Provider","Job Seeker"]
    var selectedGender = ""
    let chooseEmp = DropDown()
    
    var selectedType = ""
    var userEmail = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonSignup.setCornerRadius(radius: 5.0)
        self.buttonSignup.backgroundColor = APP_THEME_COLOR
        setupChooseEmpDropDown()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - button action
    
    @IBAction func buttonHandlerUserType(_ sender: Any) {
        chooseEmp.show()
    }
    @IBAction func buttonHandlerSignup(_ sender: Any) {
        if self.textFieldEmail.text == "" || self.textFieldPassword.text == "" || self.textFieldMobile.text == "" || self.selectedType == ""{
            showAlertWithTitleWithMessage(message: "Please complete the form")
        }else{
            if HelperFunction.helper.isValidEmail(testStr: self.textFieldEmail.text!){
                if HelperFunction.helper.isPasswordValid(self.textFieldPassword.text!){
                    
                    if (self.textFieldMobile.text?.length)! > 7 && (self.textFieldMobile.text?.length)! < 11{
                        
                        
                        self.registerUser()
                        
                    }else{
                        showAlertWithTitleWithMessage(message: "Please enter valid mobile number.(Mobile number should be 8-10 digits only)")
                    }
                }else{
                    showAlertWithTitleWithMessage(message: "Password should contain one special character and minimum 8 character required")
                }
                
            }else{
                showAlertWithTitleWithMessage(message: "Email is not valid")
            }
        }
    }
    //this button action handle gender selection
    @IBAction func buttonHandlerGender(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Gender", message: "Please select gender")
        
        let frameSizes: [String] = ["Male","Female"]
        let pickerViewValues: [[String]] = [["Male","Female"]]
        self.buttonGender.setTitle(frameSizes[0], for: .normal)
        self.selectedGender = frameSizes[0]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            self.selectedGender = frameSizes[index.row]
            self.buttonGender.setTitle(frameSizes[index.row], for: .normal)
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    print(frameSizes[index.row])
                    
                    
                }
            }
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    //go back to login screen
    @IBAction func buttonHandlerSignin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Custom methods
    func setupChooseEmpDropDown() {
        
        chooseEmp.anchorView = self.ButtonUserType
        chooseEmp.bottomOffset = CGPoint(x: 0, y: 0)
        chooseEmp.dataSource = userTypeArray
        chooseEmp.selectionAction = { [weak self] (index, item) in
            self!.selectedType = item
            self!.ButtonUserType.setTitle(item, for: .normal)
            self!.chooseEmp.hide()
        }
        
    }
    //this method is used for the register user and save data to Realm
    func registerUser(){
        
        let user = RObjUser()
        user.firstName = self.textFieldFirstName.text!
        user.lastName = self.textFieldLastName.text!
        user.email = self.textFieldEmail.text!
        user.password = self.textFieldPassword.text!
        user.type = self.selectedType
        // user.gender = self.selectedGender
        user.mobileNum = Int(self.textFieldMobile.text!)!
        let realm = try! Realm()
        let arrayData = realm.objects(RObjUser.self).filter("email == %d",self.textFieldEmail.text!)
        if arrayData.count>0{
            showAlertWithTitleWithMessage(message: "Email already exists")
        }else{
            runOnAfterTime(afterTime: 1.0) {
                DBManager.sharedInstance.addObject(object: user)
                customeSimpleAlertView(title: "Registered!", message: "Congratulations! You are successfully registered")
                
                self.userEmail = self.textFieldEmail.text!
                self.sendEmail()
                //Reset all controls after user registeration
                self.textFieldFirstName.text = ""
                self.textFieldLastName.text = ""
                self.textFieldMobile.text = ""
                self.textFieldEmail.text = ""
                self.textFieldPassword.text = ""
                
            }
            
        }
        
    }
    
    
    func sendEmail() {
        
        var html = "<h4 style=\"color: #5e9ca0;\"><strong>&nbsp;Hey new bie...,</strong></h4><h2 id=\"home-enter-address-title\" class=\"b4 b5 b6 c1 c2 c3 c4 c5\"><span style=\"color: #000080;\">Welcome to Helping Hands where you can get helper/part-timer or you can earn by completing such cleaning jobs.</span></h2><h2 class=\"box__title\"><strong><span style=\"color: #800000;\">You are registred successfully</span></strong></h2><br><h4>Go and get job and earn more or get helper/part-timer to job done<br><br>"
        
        
        if self.userEmail == "" || self.userEmail == "admin"{
            self.userEmail = "www.iosdevelopertechies@gmail.com"
        }else{
            
        }
        let send = ["name":"Helping Hands","email":"www.iosdevelopertechies@gmail.com"]
        let to = ["name":"Buddy","email":self.userEmail]
        let dic = ["sender":send,
                   "to":[to],
                   "htmlContent":html,
                   "subject":"Helping Hands - Registration successfully",
                   "replyTo":send] as [String : Any]
        
        
        
        print(dic)
        let urlSignIn = "https://api.sendinblue.com/v3/smtp/email"
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "api-key":" 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",
            "content-type":"application/json"]
        
        let json = dic.json
        
        let url = URL(string: urlSignIn)!
        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.allHTTPHeaderFields = headers
        //request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        Alamofire.request(request).responseJSON {
            (response) in
            
            print(response)
            
            guard let responseDic = response.value as? [String:Any] else{
                print("Please try again later")
                return
                
            }
            guard let messageId = responseDic["messageId"] as? String else{
                print("Please try again later")
                return
                
            }
            
            print(messageId)
        }
        //showAlertWithTitleWithMessage(message: "Please check your email for registration confirmation")
    }
    
    
}
extension Dictionary {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
    
}
