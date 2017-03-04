//
//  RegisInfoAccountViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/22/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisInfoAccountViewController: BaseViewController {
    @IBOutlet weak var txtGmail : UITextField!
    @IBOutlet weak var txtPass : UITextField!
    @IBOutlet weak var txtRepeatPass : UITextField!
    @IBOutlet weak var imgBack : UIImageView!
    @IBOutlet weak var btnRegis : UIButton!
    
    var tenVC : String = ""
    var ngaySinhVC : String = ""
    var imgPath : String = ""
    var ttHonNhan : String = ""
    var param1 : [String : String] = [:]
    var nguoi_lien_he : String = ""
    var phone_lien_he : String = ""
    var listChildren : [Children] = []
    var fileName : URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisInfoAccountViewController.backDid(gesture:))))
        txtPass.isSecureTextEntry = true
        txtRepeatPass.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertTTGD() -> String {
        let gioi_tinh = param1["gioitinh"]!
        var quan_he = ""
        var gioi_tinh_send = ""
        if gioi_tinh == "nam" {
            quan_he = "VO"
            gioi_tinh_send = "nu"
        } else {
            quan_he = "CHONG"
            gioi_tinh_send = "nam"
        }
        
        
        var result = "["
        result = result + "{" + "\"ho_ten\"" + ":" + "\"\(self.tenVC)\" , " + "\"quan_he\"" + ":" + "\"\(quan_he)\","
            + "\"ngay_sinh\":" + "\"\(self.ngaySinhVC)\" , " + "\"gioi_tinh\"" + ":" + "\"\(gioi_tinh_send)\"" + "}"
        for item in self.listChildren {
            result = result + "," + convertChildren(item: item)
        }
        result = result + "]"
        return result
    }
    
    func convertChildren(item : Children) -> String {
        var result = ""
        result = "{" + "\"ho_ten\"" + ":" + "\"\(item.name) \", " + "\"quan_he\"" + ":" + "\"CON\" , "
            + "\"ngay_sinh\":" + "\"\(item.ngaySinh)\" , " + "\"gioi_tinh\"" + ":" + "\"\(item.gioiTinh)\"" + "}"
        return result
    }
    
    @IBAction func btnRegis(_ sender : UIButton){
        
        
        let email = txtGmail.text ?? ""
        if email.contains(".com") == false {
            self.view.makeToast("Email ko đúng", duration: 2.0, position: .center)
            return
        }
        var password = txtPass.text ?? ""
        
        let confirmPass = txtRepeatPass.text ?? ""
        
        if password != confirmPass {
            self.view.makeToast("Pass ko đúng", duration: 2.0, position: .center)
            return
        }
        password = MD5(password) ?? ""
        let name = param1["name"]!
        let gioi_tinh = param1["gioitinh"]!
        let ngay_sinh = param1["ngay_sinh"]!
        let cmnd = param1["cmnd"]!
        let ngay_cap = param1["ngay_cap"]!
        let noi_cap = param1["noi_cap"]!
        let phone = param1["sdt"]!
        let dia_chi = param1["dia_chi"]!
        let nguoi_lien_he = self.nguoi_lien_he
        let phone_lien_he = self.phone_lien_he
        let hon_nhan = self.ttHonNhan
        let ttGD = self.convertTTGD()
        
        let param : [String : String] = ["email" : email.toBase64(),
                                         "password" : password.toBase64(),
                                         "name" : name.toBase64(),
                                         "gioi_tinh" : gioi_tinh.toBase64(),
                                         "ngay_sinh" : ngay_sinh.toBase64(),
                                         "cmnd" : cmnd.toBase64(),
                                         "ngay_cap" : ngay_cap.toBase64(),
                                         "noi_cap" : noi_cap.toBase64(),
                                         "phone" : phone.toBase64(),
                                         "dia_chi" : dia_chi.toBase64(),
                                         "nguoi_lien_he" : nguoi_lien_he.toBase64(),
                                         "phone_lien_he" : phone_lien_he.toBase64(),
                                         "hon_nhan" : hon_nhan.toBase64(),
                                         "thong_tin_gia_dinh" : ttGD.toBase64(),
                                         ]
//        let param : [String : String] = ["email" : email.toBase64(),
//                                         "password" : password.toBase64(),
//                                         "name" : name.toBase64(),
//                                         "gioi_tinh" : gioi_tinh.toBase64(),
//                                         "ngay_sinh" : ngay_sinh.toBase64(),
//                                         "cmnd" : cmnd.toBase64(),
//                                         "ngay_cap" : ngay_cap.toBase64(),
//                                         "noi_cap" : noi_cap.toBase64(),
//                                         "phone" : phone,
//                                         "dia_chi" : dia_chi,
//                                         "nguoi_lien_he" : nguoi_lien_he,
//                                         "phone_lien_he" : phone_lien_he,
//                                         "hon_nhan" : hon_nhan,
//                                         "thong_tin_gia_dinh" : "",
//                                         ]
        btnRegis.isEnabled = false
        self.showLoadingHUD()
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in param {
                multipartFormData.append((value.data(using: .utf8))!, withName: key)
            }
            multipartFormData.append(self.fileName!, withName: "img_path")
        }, to: "http://www.giaohangongvang.com/api/nhanvien/register",
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    self.hideLoadingHUD()
                    self.btnRegis.isEnabled = true
                    let res = response.data
                    let json = JSON.init(data: res!)
                    NSLog("\(json)")
                    let status = json["status"].stringValue
                    let warning = json["warning"].stringValue
                    self.view.makeToast(warning, duration: 2.0, position: .center)
                    if status == "success" {
                        let deadlineTime = DispatchTime.now() + .seconds(2)
                        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                            self.navigationController?.dismiss(animated: true, completion: {
                                
                            })
                        }
                    }                    
                })
                
            case .failure(let encodingError):
                self.btnRegis.isEnabled = true
                self.hideLoadingHUD()
                print("error:\(encodingError)")
            }
    })
    }
    
    
    func backDid(gesture : UITapGestureRecognizer){
        self.navigationController?.popViewController(animated: true)
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
