//
//  RObjUser.swift
//  App
//
//  Created byiOS on 24/07/20
//  Copyright © 2018 iOS. All rights reserved.
//
import Realm
import RealmSwift
import UIKit

class RObjUser: Object {
    
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var type: String?
    @objc dynamic var mobileNum = 0
    @objc dynamic var email = ""
    @objc dynamic var password: String?
   
    
//    override static func primaryKey() -> String? {
//        return "email"
//    }
//    override static func indexedProperties() -> [String] {
//        return ["firstName"]
//    }
}
