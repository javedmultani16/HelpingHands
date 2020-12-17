//
//  AppDelegate.swift
//  Helping Hands
//
//  Created by iOS on 10/06/2020.
//  Copyright © 2020 iOS developement. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import NVActivityIndicatorView
import Realm
import RealmSwift
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {
var window: UIWindow?

    var appRootController: UINavigationController?
       var navMenuController: UINavigationController?
       var navHomeController: UINavigationController?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GIDSignIn.sharedInstance().clientID = "973552138100-od1ijtc2eqnud6b74t2ho0ane170qaqs.apps.googleusercontent.com"
         GIDSignIn.sharedInstance().delegate = self
         
         let config = Realm.Configuration(
             schemaVersion: 2,
             migrationBlock: { migration, oldSchemaVersion in
                 
                 if (oldSchemaVersion < 2) {
                     // Nothing to do!
                     
                 }
         })
         Realm.Configuration.defaultConfiguration = config
         
         let configCheck = Realm.Configuration();
         do {
             let fileUrlIs = try schemaVersionAtURL(configCheck.fileURL!)
             print("schema version \(fileUrlIs)")
         } catch  {
             print(error)
         }
         // Override point for customization after application launch.
         UIApplication.shared.statusBarStyle = .lightContent
         Thread.sleep(forTimeInterval: 2.0)
         
         IQKeyboardManager.shared.enable = true
         IQKeyboardManager.shared.shouldResignOnTouchOutside = true
         IQKeyboardManager.shared.placeholderFont = THEME_FONT_LIGHT(size: 14)
         
         NVActivityIndicatorView.DEFAULT_TEXT_COLOR = UIColor.white
         NVActivityIndicatorView.DEFAULT_PADDING = CGFloat(0)
         NVActivityIndicatorView.DEFAULT_COLOR = UIColor.white
         NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
         NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 0
         NVActivityIndicatorView.DEFAULT_TYPE = .ballRotateChase
         NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE_FONT = THEME_FONT_MEDIUM(size: 20)
        return true
    }

    
    //MARK: - Google Signin
       @available(iOS 9.0, *)
          func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
            return GIDSignIn.sharedInstance().handle(url)
          }
          func application(_ application: UIApplication,
                           open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
            return GIDSignIn.sharedInstance().handle(url)
          }
          func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                    withError error: Error!) {
            if let error = error {
              if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
              } else {
                print("\(error.localizedDescription)")
              }
              return
            }
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
          }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Helping_Hands")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

