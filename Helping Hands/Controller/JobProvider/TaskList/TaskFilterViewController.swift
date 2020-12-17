//
//  TaskFilterViewController.swift
//  Helping Hands
//
//  Created by iOS on 21/06/2020.
//  Copyright © 2020 iOS developement. All rights reserved.
//

import UIKit
import DropDown
protocol TaskFilterViewControllerDelegate {
    func filterTask(from:String,to:String,status:String,cat:String)
    
}

class TaskFilterViewController: BaseVC {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var catTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    
      var delegate: TaskFilterViewControllerDelegate?
    
     let chooseCat = DropDown()
     let chooseStatus = DropDown()
    
       var catArray = ["Residential Cleaning", "Commercial Cleaning","Car Cleaning","Carpet Cleaning","Windows Cleaning","Swimming Pool Cleaning"]
    var statusArray = ["REQUESTED","ACCEPTED","COMPLETED","CANCELLED"]
    
    var selectedFromDate:Date = Date()
    var selectedToDate:Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fromTextField.addInputViewDatePicker(target: self, selector: #selector(doneFromButtonPressed))
               toTextField.addInputViewDatePicker(target: self, selector: #selector(doneToButtonPressed))
        
        self.setupChooseCatDropDown()
        self.setupChooseStatusDropDown()
        
        // Do any additional setup after loading the view.
    }
    func setupChooseCatDropDown() {
        
        chooseCat.anchorView = self.catTextField
        chooseCat.bottomOffset = CGPoint(x: 0, y: 0)
        chooseCat.dataSource = catArray
        chooseCat.selectionAction = { [weak self] (index, item) in
            self?.catTextField.text = self!.catArray[index]
              self!.chooseCat.hide()
        }
        
    }
    func setupChooseStatusDropDown() {
        
        chooseStatus.anchorView = self.statusTextField
        chooseStatus.bottomOffset = CGPoint(x: 0, y: 0)
        chooseStatus.dataSource = statusArray
        chooseStatus.selectionAction = { [weak self] (index, item) in
            self?.statusTextField.text = self!.statusArray[index]
            self!.chooseStatus.hide()
        }
        
    }
    //MARK: ========  Button Action ========
       @objc func doneFromButtonPressed() {
           if let  datePicker = self.fromTextField.inputView as? UIDatePicker {
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "MMM dd,yyyy"
               // dateFormatter.dateStyle = .medium
               self.fromTextField.text = dateFormatter.string(from: datePicker.date)
               self.selectedFromDate = dateFormatter.date(from: self.fromTextField.text!)!
               
           }
           self.fromTextField.resignFirstResponder()
       }
       
       @objc func doneToButtonPressed() {
           if let  datePicker = self.toTextField.inputView as? UIDatePicker {
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "MMM dd,yyyy"
               // dateFormatter.dateStyle = .medium
               self.toTextField.text = dateFormatter.string(from: datePicker.date)
               self.selectedToDate = dateFormatter.date(from: self.toTextField.text!)!
               
           }
           self.toTextField.resignFirstResponder()
       }
    
    @IBAction func searchHandler(_ sender: Any) {
        
        delegate?.filterTask(from: self.fromTextField.text!, to: self.toTextField.text!, status: self.statusTextField.text!, cat: self.catTextField.text!)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func closeHandler(_ sender: Any) {
   
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func categorySelect(_ sender: Any) {
        chooseCat.show()
        
    }
    
    @IBAction func statusSelect(_ sender: Any) {
        chooseStatus.show()
    }
   

}
