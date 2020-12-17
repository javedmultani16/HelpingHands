//
//  TaskDetailsViewController.swift
//  Helping Hands
//
//  Created by iOS on 21/06/2020.
//  Copyright © 2020 iOS developement. All rights reserved.
//

import UIKit
import CoreData
import SwiftIcons

class TaskDetailsViewController: BaseVC,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var stackViewButton: UIStackView!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var catLabel: UILabel!
    @IBOutlet weak var taskTableView: UITableView!
    
    var taskID = ""
    var status = ""
    var duration = ""
    var time = ""
    var date = ""
    var rate = ""
    var category = ""
    var place = ""
    
    var isJobSeeker = false
    var isAdmin = false
    var isInvitaionList = false
    
    var titleArray = ["Task ID","Status","Date","Time","Duration","Rate","Location"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.layer.cornerRadius = profilePic.frame.height / 2.0
        profilePic.clipsToBounds = true
        
        
        profilePic.borderColor = APP_THEME_COLOR
        profilePic.borderWidth = 1.5
        
        secondButton.borderColor = APP_THEME_COLOR
        secondButton.borderWidth = 1.5
        
        profilePic.image = UIImage(named: self.category)
        self.catLabel.text = self.category
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.reloadData()
        
        taskTableView.register(UINib(nibName: "TaskDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskDetailsTableViewCell")
        
        
        self.updateUI()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden (false, animated: false)
        self.setNavigationbarleft_imagename(left_icon_Name: IoniconsType.androidArrowBack, left_action: #selector(self.btnBackHandle(_:)),
                                            right_icon_Name:nil,
                                            right_action: nil,
                                            title: "Task Details")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden (true, animated: true)
        
        
        
    }
    func updateUI(){
        if self.isInvitaionList{
            self.firstButton.setTitle("Accept", for: .normal)
            self.secondButton.setTitle("Go Back", for: .normal)
        }else if self.isJobSeeker{
            if status == "REQUESTED"{
                self.firstButton.setTitle("Accept", for: .normal)
                self.secondButton.setTitle("Go Back", for: .normal)
            }else if status == "ACCEPTED"{
                self.firstButton.setTitle("Completed", for: .normal)
                self.secondButton.setTitle("Cancel Task", for: .normal)
            }else if status == "COMPLETED"{
                self.stackViewButton.isHidden = true
            }else if status == "CANCELLED"{
                self.stackViewButton.isHidden = true
            }
        }else{//job provider
            if status == "REQUESTED"{
                self.firstButton.setTitle("Go Back", for: .normal)
                self.secondButton.setTitle("Cancel Task", for: .normal)
            }else if status == "ACCEPTED"{
                self.firstButton.setTitle("Completed", for: .normal)
                self.secondButton.setTitle("Cancel Task", for: .normal)
            }else if status == "COMPLETED"{
                self.stackViewButton.isHidden = true
            }else if status == "CANCELLED"{
                self.stackViewButton.isHidden = true
            }
        }
        
        
        self.taskTableView.reloadData()
    }
    @IBAction func firstButtonHandler(_ sender: Any) {
        if self.isInvitaionList{
            self.accepted()
        }else if self.isJobSeeker{
            if status == "REQUESTED"{
                self.accepted()
            }else if status == "ACCEPTED"{
                self.completed()
            }else if status == "COMPLETED"{
                self.stackViewButton.isHidden = true
            }else if status == "CANCELLED"{
                self.stackViewButton.isHidden = true
            }
        }else{//job provider
            if status == "REQUESTED"{
                self.navigationController?.popViewController(animated: true)
                
            }else if status == "ACCEPTED"{
                self.completed()
            }else if status == "COMPLETED"{
                self.stackViewButton.isHidden = true
            }else if status == "CANCELLED"{
                self.stackViewButton.isHidden = true
            }
        }
        
    }
    
    @IBAction func secondButtonHandler(_ sender: Any) {
        if self.isInvitaionList{
            
            self.navigationController?.popViewController(animated: true)
            
        }else if self.isJobSeeker{
            if status == "REQUESTED"{
                self.navigationController?.popViewController(animated: true)
            }else if status == "ACCEPTED"{
                self.cancel()
            }else if status == "COMPLETED"{
                self.stackViewButton.isHidden = true
            }else if status == "CANCELLED"{
                self.stackViewButton.isHidden = true
            }
        }else{//job provider
            if status == "REQUESTED"{
                self.cancel()
            }else if status == "ACCEPTED"{
                self.cancel()
            }else if status == "COMPLETED"{
                self.stackViewButton.isHidden = true
            }else if status == "CANCELLED"{
                self.stackViewButton.isHidden = true
            }
        }
        
    }
    
    func cancel(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        
        request.predicate = NSPredicate(format: "taskID = %@", self.taskID)
        request.returnsObjectsAsFaults = false
        do{
            let results = try managedContext.fetch(request)
            let objectUpdate = results[0] as! NSManagedObject
            objectUpdate.setValue("CANCELLED", forKey: "status")
            
            do {
                try managedContext.save()
                self.status = "CANCELLED"
                self.updateUI()
                showAlertWithTitleWithMessage(message: "Task Cancelled Successfully")
            }catch let error as NSError {
                showAlertWithTitleWithMessage(message: "Please try again")
            }
            
            self.taskTableView.reloadData()
        }catch{
            print("error while fetching....")
        }
    }
    func completed(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        
        request.predicate = NSPredicate(format: "taskID = %@", self.taskID)
        request.returnsObjectsAsFaults = false
        do{
            let results = try managedContext.fetch(request)
            let objectUpdate = results[0] as! NSManagedObject
            objectUpdate.setValue("COMPLETED", forKey: "status")
            
            do {
                try managedContext.save()
                self.status = "COMPLETED"
                self.updateUI()
                showAlertWithTitleWithMessage(message: "Task Completed Successfully")
            }catch let error as NSError {
                showAlertWithTitleWithMessage(message: "Please try again")
            }
            
            self.taskTableView.reloadData()
        }catch{
            print("error while fetching....")
        }
    }
    func accepted(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        
        request.predicate = NSPredicate(format: "taskID = %@", self.taskID)
        request.returnsObjectsAsFaults = false
        do{
            
            let helper = HelperFunction.helper.FetchFromUserDefault(name:"username")
            let results = try managedContext.fetch(request)
            let objectUpdate = results[0] as! NSManagedObject
            objectUpdate.setValue("ACCEPTED", forKey: "status")
            objectUpdate.setValue(helper, forKey: "helper")
            do {
                try managedContext.save()
                self.status = "ACCEPTED"
                self.updateUI()
                showAlertWithTitleWithMessage(message: "Task Accepted Successfully")
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TaskAcceptedViewController") as? TaskAcceptedViewController
                self.navigationController?.pushViewController(vc!, animated: true)
                //
            }catch let error as NSError {
                showAlertWithTitleWithMessage(message: "Please try again")
            }
            
            self.taskTableView.reloadData()
        }catch{
            print("error while fetching....")
        }
    }
    //MARK: ======== UITableViewDataSource ==============
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskDetailsTableViewCell", for: indexPath) as! TaskDetailsTableViewCell
        cell.titleLabel.text = self.titleArray[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.ansLabel.text = "#" + self.taskID
        case 1:
            
            cell.ansLabel.text = ""//objTask?.status ?? 0
            let status = self.status
            
            if status == "REQUESTED"{
                cell.ansLabel.text = "REQUESTED"
                cell.ansLabel.textColor = APP_PENDING_COLOR
            }else if status == "ACCEPTED"{
                cell.ansLabel.text = "ACCEPTED"
                cell.ansLabel.textColor = APP_ACCEPTED_COLOR
                
            }else if status == "COMPLETED"{
                cell.ansLabel.text = "COMPLETED"
                cell.ansLabel.textColor =  APP_COMPLETED_COLOR
                
            }else if status == "CANCELLED"{
                cell.ansLabel.text = "CANCELLED"
                cell.ansLabel.textColor =  APP_CANCELLED_COLOR
            }
            
        case 2:
            cell.ansLabel.text = self.date
        case 3:
            cell.ansLabel.text = self.time
        case 4:
            
            cell.ansLabel.text = self.duration 
        case 5:
            cell.ansLabel.text = self.rate + " $"
        case 6:
            cell.ansLabel.text = self.place
            
        default:
            cell.detailTextLabel?.text = ""
        }
        return cell
        
        
    }
}
