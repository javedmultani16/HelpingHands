//
//  AddTaskViewController.swift
//  Helping Hands
//
//  Created by iOS on 13/06/2020.
//  Copyright © 2020 iOS developement. All rights reserved.
//

import UIKit
import CoreData
import SwiftIcons
import DropDown

class AddTaskViewController: BaseVC {
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var catTextField: UITextField!
    
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
     var selectedDate:Date = Date()
    
        let chooseEmp = DropDown()
    
    var categoryArray = ["Residential Cleaning", "Commercial Cleaning","Car Cleaning","Carpet Cleaning","Windows Cleaning","Swimming Pool Cleaning"]
    
    var taskID = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.layer.cornerRadius = profilePic.frame.height / 2.0
        profilePic.clipsToBounds = true
        
        
        profilePic.borderColor = APP_THEME_COLOR
        profilePic.borderWidth = 1.5
        
        self.setupChooseDropDown()
       
        dateTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
        timeTextField.addInputViewTimePicker(target: self, selector: #selector(doneTimeButtonPressed))
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden (false, animated: false)
        self.setNavigationbarleft_imagename(left_icon_Name: IoniconsType.androidArrowBack, left_action: #selector(self.btnBackHandle(_:)),
                                            right_icon_Name:nil,
                                            right_action: nil,
                                            title: "Add Task")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden (true, animated: true)
        
        
    }
    @objc func doneButtonPressed() {
       if let  datePicker = self.dateTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
           //datePicker.maximumDate = Date()
            dateFormatter.dateFormat = "MMM dd,yyyy"
          // dateFormatter.dateStyle = .medium
           self.dateTextField.text = dateFormatter.string(from: datePicker.date)
           self.selectedDate = dateFormatter.date(from: self.dateTextField.text!)!
        
       }
       self.dateTextField.resignFirstResponder()
    }
    @objc func doneTimeButtonPressed() {
       if let  datePicker = self.timeTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
       // datePicker.datePickerMode = .dateAndTime
      
           //datePicker.maximumDate = Date()
           dateFormatter.dateFormat = "HH:mm a"
          // dateFormatter.dateStyle = .medium
        self.timeTextField.text = dateFormatter.string(from: datePicker.date)
          // self.selectedDate = dateFormatter.date(from: self.timeTextField.text!)!
        
       }
       self.timeTextField.resignFirstResponder()
    }
    
    
    @IBAction func buttonShowCategory(_ sender: Any) {
        self.chooseEmp.show()
    }
    func setupChooseDropDown() {
        
        chooseEmp.anchorView = self.catTextField
        chooseEmp.bottomOffset = CGPoint(x: 0, y: 0)
        chooseEmp.dataSource = categoryArray
        chooseEmp.selectionAction = { [weak self] (index, item) in
            self?.catTextField.text = self!.categoryArray[index]
            self?.profilePic.image = UIImage(named: self!.categoryArray[index])
//            self!.selectedType = item
//            self!.buttonUserType.setTitle(item, for: .normal)
            self!.chooseEmp.hide()
        }
        
    }
    func addTask(){
        
        if self.catTextField.text == "" || self.dateTextField.text! == "" || self.timeTextField.text! == "" || self.placeTextField.text! == "" || self.rateTextField.text! == "" || self.durationTextField.text! == ""{
            showAlertWithTitleWithMessage(message: "Please Enter All Details")
        }else{
            
            taskID = HelperFunction.helper.FetchIntFromUserDefault(name: "taskID")
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName:"Tasks", in: context)
            let new = NSManagedObject(entity: entity!, insertInto: context)
            
            
            let creator = HelperFunction.helper.FetchFromUserDefault(name:"username")
            
            new.setValue(creator, forKey:"createdBy")
            new.setValue(self.catTextField.text!, forKey:"category")
            new.setValue(self.selectedDate, forKey:"date")
            new.setValue(self.durationTextField.text!, forKey:"duration")
            new.setValue(self.placeTextField.text!, forKey:"place")
            new.setValue("REQUESTED", forKey:"status")
            new.setValue(self.timeTextField.text!, forKey:"time")
            new.setValue(self.rateTextField.text!, forKey:"rate")
            new.setValue(String(taskID+1), forKey:"taskID")
            
            
            do{
                try context.save()
                //                DispatchQueue.main.async {
                //                    self.saveImageDocumentDirectory(image: self.selectedImage!, imageName: self.nameTextField.text!)
                //                }
                HelperFunction.helper.storeIntUserDefaultForKey(name: "taskID", val: taskID+1)
                showAlertWithTitleWithMessage(message: "Task Added Successfully")
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TaskSuccessfullyAddedViewController") as? TaskSuccessfullyAddedViewController
                self.navigationController?.pushViewController(vc!, animated: true)
                //  self.navigationController?.popViewController(animated: true)
                print("Data added successfully....")
            }catch{
                print("Error while inserting data....")
                showAlertWithTitleWithMessage(message: "Please try again")
            }
        }
    }
    
    @IBAction func buttonHandlerAdd(_ sender: Any) {
        
        self.addTask()
    }
    
    
}

extension UITextField {
      func addInputViewTimePicker(target: Any, selector: Selector) {

       let screenWidth = UIScreen.main.bounds.width

       //Add DatePicker as inputView
       let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
       datePicker.datePickerMode = .time
       datePicker.minimumDate = Date()
      // datePicker.backgroundColor = .white
       self.inputView = datePicker

       //Add Tool Bar as input AccessoryView
       let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
       let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
       let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
       let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
       toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

       self.inputAccessoryView = toolBar
    }

   func addInputViewDatePicker(target: Any, selector: Selector) {

    let screenWidth = UIScreen.main.bounds.width

    //Add DatePicker as inputView
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
    datePicker.datePickerMode = .date
    datePicker.minimumDate = Date()
   // datePicker.backgroundColor = .white
    self.inputView = datePicker

    //Add Tool Bar as input AccessoryView
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
    let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
    toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

    self.inputAccessoryView = toolBar
 }
    func addInputViewDateTimePicker(target: Any, selector: Selector) {

       let screenWidth = UIScreen.main.bounds.width

       //Add DatePicker as inputView
       let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
       datePicker.datePickerMode = .dateAndTime
       datePicker.minimumDate = Date()
      // datePicker.backgroundColor = .white
       self.inputView = datePicker

       //Add Tool Bar as input AccessoryView
       let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
       let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
       let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
       let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
       toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

       self.inputAccessoryView = toolBar
    }
   @objc func cancelPressed() {
     self.resignFirstResponder()
   }
}
