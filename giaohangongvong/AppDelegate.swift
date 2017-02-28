//
//  AppDelegate.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/19/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import IQKeyboardManagerSwift
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var slideMenu : SlideMenuController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        IQKeyboardManager.sharedManager().enable = true
        if UserDefaults.standard.value(forKey: "session") == nil {
            let mainVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            self.window?.rootViewController = mainVC
            self.window?.makeKeyAndVisible()
        } else {
            let mainVC = MainViewController(nibName: "MainViewController", bundle: nil)
            self.window?.rootViewController = mainVC
            self.window?.makeKeyAndVisible()
        }
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
        if UserDefaults.standard.value(forKey: "Username") == nil {
            return
        }
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataPath = documentsDirectory.appendingPathComponent("GHOV")
        let folders = try? FileManager.default.contentsOfDirectory(atPath: dataPath.path)
        if folders != nil {
            for folder in folders! {
                let tmp = dataPath.appendingPathComponent("\(folder)")
                let count1 = try? FileManager.default.contentsOfDirectory(atPath: tmp.path)
                if count1 != nil {
                    if (count1?.count != 0) {
                        
                        for image in count1! {
                                //name image
                            //folder : folder
                            let file = tmp.appendingPathComponent(image)
                            
                            let email = (UserDefaults.standard.value(forKey: "Username") as! String)
                            let dateFormat = DateFormatter()
                            dateFormat.dateFormat = "yyMMdd"
                            let date = dateFormat.string(from: Date()).toBase64()
                            let soluongdon = "\(count1?.count)".toBase64()
                            //folder containt 3
                            let strings = folder.components(separatedBy: "@")
                            
                            let shop = strings[1].toBase64()
                            let nhanvien = strings[2].toBase64()
                            let name_file = "\(image)".toBase64()
                            let name_folder = "\(strings[0])".toBase64()
                            let param : [String : String] = ["session_id" : getSession(),
                                                             "email": email.toBase64(),
                                                             "date" : date,
                                                             "soluongdon" : soluongdon,
                                                             "shop" : shop,
                                                             "nhanvien" : nhanvien,
                                                             "name_file" : name_file,
                                                             "name_folder" : name_folder,
                                                             ]
                            //let url = Bundle.main.url(forResource: "2", withExtension: "jpg")
                            Alamofire.upload(multipartFormData: { multipartFormData in
                                for (key, value) in param {
                                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                                }
                                multipartFormData.append(file, withName: "uploaded_file")
                            }, to: "http://www.giaohangongvang.com/files/upload",
                               encodingCompletion: { encodingResult in
                                switch encodingResult {
                                case .success(let upload, _, _):
                                    upload.responseString(completionHandler: { (response) in
                                        let res = response.value ?? ""
                                        switch res {
                                        case "login_fail":
                                            Alamofire.request("http://www.giaohangongvang.com/files/upload", method: .post, parameters: param).responseJSON(completionHandler: { (response) in
                                                let data = JSON.init(data: response.data!)
                                                NSLog("Anh ne: \(data)")
                                                let status = data["status"].stringValue
                                                if status == "fail" {
                                                    let param : [String : String] = ["session" : self.getSession()]
                                                    Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/logout", method: .post, parameters: param).responseJSON(completionHandler: { (response) in
                                                        UserDefaults.standard.removeObject(forKey: "session")
                                                        if response.response?.statusCode == 200 {
                                                            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
                                                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                            appDelegate.window?.rootViewController = loginVC
                                                        }
                                                    })
                                                }
                                            })
                                        case "success":
                                            try? FileManager.default.removeItem(at: file)
                                            break
                                        default:
                                            break
                                        }
                                    })
                                    
                                case .failure(let encodingError):
                                    print("error:\(encodingError)")
                                }
                            })

                        }
                    } else if count1 != nil {
                        NSLog("Delete \(folder)")
                        try? FileManager.default.removeItem(at: dataPath.appendingPathComponent("/\(folder)"))
                    }
                }
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func getSession() -> String {
        return (UserDefaults.standard.value(forKey: UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.session)) as! String).toBase64()
    }

}

