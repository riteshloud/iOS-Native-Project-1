//
//  AppDelegate.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit
import Localize_Swift
import AKSideMenu
import IQKeyboardManagerSwift
import Firebase
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UIStackView.self)
        GlobalData.shared.customizationSVProgressHUD()
        //If User enable biometric then we need to show biometric reauthorisation on every app launch while accessing the OTM Trade Dashboard (Home)
        defaults.set(false, forKey: isReauthDialogDisplayed)
        defaults.synchronize()

        if defaults.value(forKey: kCurrentLanguage) == nil {
            defaults.set(Language.English.rawValue, forKey: kCurrentLanguage)
            defaults.synchronize()
            self.setupUserLanguage()
        }
        
        let siren = Siren.shared
        siren.rulesManager = RulesManager(globalRules: .critical)
        siren.wail()
        
        self.setAppearance()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if GlobalData.shared.nBiometricErrorCode == -8 {
            let alertController = UIAlertController(title: nil, message: "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times.".localized(), preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "OK".localized(), style: .default) { (action) in
                
                defaults.set(false, forKey: isReauthDialogDisplayed)
                defaults.synchronize()
                exit(0)
            }
            
            alertController.addAction(okAction)
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            //            self.present(alertController, animated: true, completion: nil)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK:- Set Appearance
    func setAppearance() {
        UITabBar.appearance().barTintColor = UIColor.black
        UITabBar().itemWidth = UIScreen.main.bounds.width / 4.0
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.init(name: Fonts.PoppinsLight, size: 10.0)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.init(name: Fonts.PoppinsLight, size: 10.0)!], for: .selected)
    }

    //MARK:- Set Language
    func setupUserLanguage() {
        if defaults.object(forKey: kCurrentLanguage) as! String == Language.English.rawValue {
            Localize.setCurrentLanguage("en")
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Chinese.rawValue {
            Localize.setCurrentLanguage("zh-Hans")
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.ChineseTraditional.rawValue {
            Localize.setCurrentLanguage("zh-Hant")
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Korean.rawValue {
            Localize.setCurrentLanguage("ko")
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Thai.rawValue {
            Localize.setCurrentLanguage("th")
        }
        else if defaults.object(forKey: kCurrentLanguage) as! String == Language.Vietnam.rawValue {
            Localize.setCurrentLanguage("vi")
        }
    }
    
    //MARK:- Logout User
    func logoutUser() {
        defaults.removeObject(forKey: "userPayloadData")
        defaults.removeObject(forKey: "_token")
        
        defaults.set(false, forKey: isBiometricDialogDiplayed)
        defaults.set(false, forKey: isReauthDialogDisplayed)
        defaults.set(false, forKey: isAnnouncementDisplayed)
        
        defaults.set(false, forKey: kIsUserLoggedIn)
        defaults.removeObject(forKey: kLoggedInUserData)
        defaults.synchronize()
                
        DispatchQueue.main.async() {
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "InitialVC") as! InitialVC
            let navigationController = UINavigationController(rootViewController: vc)
            appDelegate.window?.rootViewController = navigationController
        }
    }
}

