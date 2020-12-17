//
//  CategoryViewController.swift
//  Helping Hands
//
//  Created by iOS on 13/06/2020.
//  Copyright © 2020 iOS developement. All rights reserved.
//

import UIKit

import SDWebImage
import SwiftIcons
import SwiftyJSON
import RealmSwift
import Realm
import SYPhotoBrowser

class CategoryViewController:  BaseVC,UICollectionViewDelegate, UICollectionViewDataSource {
    
    var titleArray = ["Residential Cleaning", "Commercial Cleaning","Car Cleaning","Carpet Cleaning","Windows Cleaning","Swimming Pool Cleaning"]
     var imageArray = ["home-cleaning","commercial-cleaning","car-cleaning","carpet-cleaning-img","Windows-Cleaning","swimming_pool-cleaning"]
     
     var arrayPhotoURL = [String]()
     
     @IBOutlet weak var collectionViewCategory: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
           collectionViewCategory.delegate = self
            collectionViewCategory.dataSource = self
            
            collectionViewCategory.backgroundColor = CLEAR_COLOR;
            
            let spacingCell : CGFloat = 8.0
            let cellSize : CGFloat = (SCREENWIDTH() - spacingCell*3)/2
            let collectionViewLayout: UICollectionViewFlowLayout = (collectionViewCategory!.collectionViewLayout as! UICollectionViewFlowLayout)
            collectionViewLayout.sectionInset = UIEdgeInsetsMake(spacingCell, spacingCell, spacingCell, spacingCell)
            collectionViewLayout.minimumInteritemSpacing = spacingCell
            collectionViewLayout.itemSize = CGSize(width: cellSize, height: cellSize*0.8)
            collectionViewLayout.scrollDirection = .vertical
            
            collectionViewCategory.showsHorizontalScrollIndicator = false
            collectionViewCategory.showsVerticalScrollIndicator = false
            
            collectionViewCategory.register(UINib.init(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
            
         
            collectionViewCategory.reloadData()
           
            // Do any additional setup after loading the view.
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
               self.navigationController?.setNavigationBarHidden (false, animated: false)
              self.setNavigationbarleft_imagename(left_icon_Name: IoniconsType.androidArrowBack, left_action: #selector(self.btnBackHandle(_:)),
                                                          right_icon_Name:nil,
                                                          right_action: nil,
                                                          title: "Available Categories")
           
        }

    override func viewWillDisappear(_ animated: Bool) {
             super.viewWillDisappear(true)
                self.navigationController?.setNavigationBarHidden (true, animated: true)
              
            
         }
    
        //MARK: - Colllectionview Method
        func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return titleArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell",for:indexPath) as! ImageCollectionViewCell
          // let img = indexPath.row + 1
            let img = titleArray[indexPath.row]
            cell.imageViewGallery.image = UIImage(named: "\(img)")
            cell.setCornerRadius(radius: 7)
            cell.titleLabel.text = titleArray[indexPath.row]
            cell.backgroundColor = APP_WHITE_COLOR
            
            return cell;
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
//            let homeVC = loadVC(storyboardMain, "ListViewController") as! ListViewController
//            homeVC.categoryIndex = indexPath.row
//            homeVC.category =  titleArray[indexPath.row]
//                                      self.navigationController?.pushViewController(homeVC, animated: true)
                                  
            
        }
        //MARK: - custom method
        
    }
