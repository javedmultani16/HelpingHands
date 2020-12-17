//
//  TaskListViewController.swift
//  Helping Hands
//
//  Created by iOS on 21/06/2020.
//  Copyright © 2020 iOS developement. All rights reserved.
//
import SwiftIcons
import UIKit
import CoreData

class TaskListViewController: BaseVC,UITableViewDelegate,UITableViewDataSource,TaskFilterViewControllerDelegate {
    
    @IBOutlet weak var taskTableView: UITableView!
    
    var isInvitaionList = false
    var isJobSeeker = false
    var isAdmin = false
    var arrayTask = [NSManagedObject]()
    
    var predicateStr = ""
    
    @IBOutlet weak var catLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = APP_GRAYBG_COLOR
        taskTableView.backgroundColor = CLEAR_COLOR
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.reloadData()
        
        taskTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden (false, animated: false)
        
        if self.isInvitaionList{
            self.setNavigationbarleft_imagename(left_icon_Name: IoniconsType.androidArrowBack, left_action: #selector(self.btnBackHandle(_:)),
                                                right_icon_Name:nil,
                                                right_action: nil,
                                                title: "Task-List")
            self.fetchInvitationList()
            
        }else if self.isJobSeeker{
            self.setNavigationbarleft_imagename(left_icon_Name: IoniconsType.androidArrowBack, left_action: #selector(self.btnBackHandle(_:)),
                                                right_icon_Name:IoniconsType.iosFilingOutline,
                                                right_action: #selector(self.btnFilterHandle(_:)),
                                                title: "Task-List")
            self.fetchJobSeekerData(from: "", to: "", status: "", cat: "")
        }else{
            self.setNavigationbarleft_imagename(left_icon_Name: IoniconsType.androidArrowBack, left_action: #selector(self.btnBackHandle(_:)),
                                                right_icon_Name:IoniconsType.iosFilingOutline,
                                                right_action: #selector(self.btnFilterHandle(_:)),
                                                title: "Task-List")
            self.fetchJobProviderData(from: "", to: "", status: "", cat: "")
        }
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden (true, animated: true)
        
        
    }
    
    
    @IBAction func btnFilterHandle(_ sender: Any) {
        self.view.endEditing(true)
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TaskFilterViewController") as? TaskFilterViewController
        vc?.delegate = self
        self.present(vc!, animated: true, completion: nil)
    }
    
    func filterTask(from:String,to:String,status:String,cat:String){
        print(from,to,status,cat)
        if self.isJobSeeker{
            self.fetchJobSeekerData(from: from, to: to, status: status, cat: cat)
        }else{
            self.fetchJobProviderData(from: from, to: to, status: status, cat: cat)
        }
        
    }
    
    func fetchInvitationList(){
        
        self.arrayTask.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        let sort = NSSortDescriptor(key: "taskID", ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = NSPredicate(format: "status = %@", "REQUESTED")
        request.returnsObjectsAsFaults = false
        
        
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                self.arrayTask.append(data)
                
            }
            self.taskTableView.reloadData()
        }catch{
            print("error while fetching....")
        }
    }
    func fetchJobProviderData(from:String?,to:String?,status:String?,cat:String?){
        let creator = HelperFunction.helper.FetchFromUserDefault(name:"username")
        self.arrayTask.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        // request.predicate = NSPredicate(format: "createdBy = %@", creator)
        
        let createdPredicate =  NSPredicate(format: "createdBy = %@", creator)
        
        var predicateArray:[NSPredicate] = [NSPredicate]()
        predicateArray.append(createdPredicate)
        
        
        
        
        if status != ""{
            let statusPredicate =  NSPredicate(format: "status = %@", status!)
            predicateArray.append(statusPredicate)
            
        }
        
        if cat != ""{
            let catPredicate = NSPredicate(format:"category = %@", cat!)
            predicateArray.append(catPredicate)
        }
        if from != ""{
            
            //==================
            let fromdate = from!//"Jun 20,2020"
            let todate = to!//"Jun 30,2020"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd,yyyy"
            //dateFormatter.timeZone = NSTimeZone(name: "GMT") // this line resolved me the issue of getting one day less than the selected date
            let startDate:Date = dateFormatter.date(from: fromdate)!
            let endDate:Date = dateFormatter.date(from: todate)!
            let datePredicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate as CVarArg, endDate as CVarArg)
            predicateArray.append(datePredicate)
        }
        
        
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicateArray)
        print(andPredicate.subpredicates)
        ///==========
        request.predicate = andPredicate
        
        let sort = NSSortDescriptor(key: "taskID", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                self.arrayTask.append(data)
                
            }
            self.taskTableView.reloadData()
        }catch{
            print("error while fetching....")
        }
    }
    func fetchJobSeekerData(from:String?,to:String?,status:String?,cat:String?){
        let helper = HelperFunction.helper.FetchFromUserDefault(name:"username")
        self.arrayTask.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        // request.predicate = NSPredicate(format: "createdBy = %@", creator)
        
        let createdPredicate =  NSPredicate(format: "helper = %@", helper)
        
        var predicateArray:[NSPredicate] = [NSPredicate]()
        predicateArray.append(createdPredicate)
        
        
        
        
        if status != ""{
            let statusPredicate =  NSPredicate(format: "status = %@", status!)
            predicateArray.append(statusPredicate)
            
        }
        
        if cat != ""{
            let catPredicate = NSPredicate(format:"category = %@", cat!)
            predicateArray.append(catPredicate)
        }
        if from != ""{
            
            //==================
            let fromdate = from!//"Jun 20,2020"
            let todate = to!//"Jun 30,2020"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd,yyyy"
            //dateFormatter.timeZone = NSTimeZone(name: "GMT") // this line resolved me the issue of getting one day less than the selected date
            let startDate:Date = dateFormatter.date(from: fromdate)!
            let endDate:Date = dateFormatter.date(from: todate)!
            let datePredicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate as CVarArg, endDate as CVarArg)
            predicateArray.append(datePredicate)
        }
        
        
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicateArray)
        print(andPredicate.subpredicates)
        ///==========
        request.predicate = andPredicate
        
        let sort = NSSortDescriptor(key: "taskID", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                self.arrayTask.append(data)
                
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
        return self.arrayTask.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 170
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        
        
        let obj = self.arrayTask[indexPath.row]
        cell.nameLabel.text = (obj.value(forKey: "category") as! String)
        cell.profilePic.image = UIImage(named: cell.nameLabel.text!)
        let dte = obj.value(forKey: "date") as! Date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        // dateFormatter.dateStyle = .medium
        let dt = dateFormatter.string(from: dte)
        
        let time = obj.value(forKey: "time") as! String
        
        if self.isJobSeeker {
            let user = (obj.value(forKey: "createdBy") as! String)
            cell.catLabel.text = user
        }else if self.isInvitaionList{
            let user = (obj.value(forKey: "createdBy") as! String)
            cell.catLabel.text = user
        }else{
            let user = (obj.value(forKey: "helper") as? String ?? "")
            cell.catLabel.text = user
        }
        
        cell.timeLabel.text = String("\(dt) @ \(time)")
        cell.durationLabel.text = (obj.value(forKey: "duration") as! String) + " hr"
        cell.pointLabel.text = (obj.value(forKey: "place") as! String)
        cell.statusLabel.text = (obj.value(forKey: "status") as! String)
        cell.idLabel.text = "#" + (obj.value(forKey: "taskID") as! String)
        cell.rateLabel.text = (obj.value(forKey: "rate") as! String)
        let status =  (obj.value(forKey: "status") as! String)
        
        cell.statusLabel.text = status
        
        if status == "REQUESTED"{
            cell.statusLabel.backgroundColor = APP_PENDING_COLOR
        }else if status == "ACCEPTED"{
            cell.statusLabel.backgroundColor = APP_ACCEPTED_COLOR
        }else if status == "COMPLETED"{
            cell.statusLabel.backgroundColor = APP_COMPLETED_COLOR
        }else if status == "CANCELLED"{
            cell.statusLabel.backgroundColor = APP_CANCELLED_COLOR
        }
        // cell.rateLabel.text =
        //accpeted - start/cancel
        //ongoing - complete/cancel
        
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ["Task ID","Status","Date","Time","Duration","Rate","Category",place]
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TaskDetailsViewController") as? TaskDetailsViewController
        
        let obj = self.arrayTask[indexPath.row]
        
        vc?.duration = (obj.value(forKey: "duration") as! String) + " hr"
        vc?.place = (obj.value(forKey: "place") as! String)
        vc?.status = (obj.value(forKey: "status") as! String)
        vc?.taskID = (obj.value(forKey: "taskID") as! String)
        vc?.rate = (obj.value(forKey: "rate") as! String)
        vc?.time =  (obj.value(forKey: "time") as! String)
        vc?.category =  (obj.value(forKey: "category") as! String)
        
        let dte = (obj.value(forKey: "date") as! Date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        // dateFormatter.dateStyle = .medium
        let dt = dateFormatter.string(from: dte)
        vc?.date = dt
        
        if self.isJobSeeker{
            vc?.isJobSeeker = true
        }else if self.isInvitaionList{
            vc?.isInvitaionList = true
        }
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
}
