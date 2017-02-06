//
//  LoginViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/20/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import SlideMenuControllerSwift
import SwiftyJSON


class LoginViewController: BaseViewController {
    @IBOutlet weak var txtUserName : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var lblRegis : UILabel!
    @IBOutlet weak var btnLogin : UIButton!
    @IBOutlet weak var showPassword : UIButton!
    @IBOutlet weak var viewShowPassWord : UIView!
    @IBOutlet weak var imgChecked : UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblRegis.isUserInteractionEnabled = true
        lblRegis.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.lblRegisTap(_:))))
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismisKeyboard(_:))))
        txtUserName.text = "test@gmail.com"
        txtPassword.text = "123"
        txtPassword.isSecureTextEntry = true
        viewShowPassWord.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.btnShowPassTouchUp(gesture:))))
    }
    
    func dismisKeyboard(_ gesture : UITapGestureRecognizer) {
        txtUserName.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }
    
    func lblRegisTap(_ gesture : UITapGestureRecognizer) {
        let regisVC = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: regisVC)
        nav.isNavigationBarHidden = true
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func btnShowPassTouchUp(gesture : UITapGestureRecognizer) {
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
        if txtPassword.isSecureTextEntry {
            imgChecked.image = UIImage.init(named: "unchecked")
        } else {
            imgChecked.image = UIImage.init(named: "checked")
        }
    }
    
    @IBAction func loginTouchUp(_ sender : Any) {
        self.showLoadingHUD()
        let username = txtUserName.text
        let password = txtPassword.text
        
        let k = username?.toBase64()
        let h = MD5(password!)?.toBase64()
        
        let parameters: [String: String] = [
            "email" : k!,
            "password" : h!
        ]
        Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/login", method: .post, parameters: parameters)
            .responseJSON { response in
                //print(response)
                
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                let mainVC = MainViewController(nibName: "MainViewController", bundle: nil)
                let json = JSON(data: response.data!)
                let details = json["detail"]
                let session = details["session_id"].stringValue 
                let ho_ten = details["ho_ten"].stringValue 
                let id_thanh_pho = details["id_thanh_pho"].stringValue
                let id_quan = details["id_quan"].stringValue
                let id_phuong = details["id_phuong"].stringValue
                
                UserDefaults.standard.set(session, forKey: UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.session))
                UserDefaults.standard.set(id_thanh_pho, forKey: UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.id_tp))
                UserDefaults.standard.set(id_quan, forKey: UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.id_quan))
                UserDefaults.standard.set(id_phuong, forKey: UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.id_phuong))
                UserDefaults.standard.set(ho_ten, forKey: UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.ho_ten))
                NSLog("\(session.toBase64())")
                self.hideLoadingHUD()
                appdelegate.window?.rootViewController = mainVC
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func MD5(_ string: String) -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        if let d = string.data(using: String.Encoding.utf8) {
            d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
    
    
}


