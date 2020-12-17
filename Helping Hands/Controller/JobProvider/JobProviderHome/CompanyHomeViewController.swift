//
//  CompanyHomeViewController.swift
//  Helping Hands
//
//  Created by iOS on 13/06/2020.
//  Copyright © 2020 iOS developement. All rights reserved.
//

import UIKit

class CompanyHomeViewController: BaseVC {
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    
    var imgArr = [  UIImage(named:"c1"),
                    UIImage(named:"c2") ,
                    UIImage(named:"c3") ,
                    UIImage(named:"c4") ,
                    UIImage(named:"c5")  ]
    
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        pageView.numberOfPages = imgArr.count
        pageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
        //MARK: - Button action
    
    @IBAction func settingHandler(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
          
              self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @IBAction func buttonHandlerCategory(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController
        
            self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func buttonHandlerAddTaask(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTaskViewController") as? AddTaskViewController
            
                self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func buttonHandlerTaskList(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TaskListViewController") as? TaskListViewController
                self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @IBAction func buttonHandlerLogout(_ sender: Any) {
   let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
        
            self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func changeImage() {
        
        if counter < imgArr.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
        
    }
}

extension CompanyHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView {
            vc.image = imgArr[indexPath.row]
        }
        return cell
    }
}

extension CompanyHomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

