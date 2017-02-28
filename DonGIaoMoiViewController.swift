//
//  DonGIaoMoiViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/14/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class Quan : NSObject{
    var id_quan : String
    var ten_quan : String
    init(json : JSON) {
        self.id_quan = json["id_quan"].stringValue
        self.ten_quan = json["ten_quan"].stringValue
    }
}

class TP : NSObject {
    var id_thanh_pho : String
    var ten_thanh_pho : String
    var quans : [Quan]?
    init(json : JSON) {
        quans = [Quan]()
        self.id_thanh_pho = json["id_thanh_pho"].stringValue
        self.ten_thanh_pho = json["ten_thanh_pho"].stringValue
        if json["quan"].arrayValue.count != 0 {
            for item in json["quan"].arrayValue {
                let quan = Quan(json: item)
                quans?.append(quan)
            }
        }
    }
}

class DonGIaoMoiViewController: BaseViewController {
    @IBOutlet weak var txtDiaChi : UITextView!
    @IBOutlet weak var txtTP : UITextField!
    @IBOutlet weak var txtQuan : UITextField!
    var pickerTP = UIPickerView()
    var pickerQuan = UIPickerView()
    var listTP = [TP]()
    
    var chooseTP : Int?
    var chooseQuan : Int?
    
    var sdt : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupController?.navigationBarHidden = true
        self.contentSizeInPopup  = CGSize(width: 300, height: 230)
        txtTP.inputView = pickerTP
        pickerTP.delegate = self
        pickerTP.dataSource = self
        txtQuan.inputView = pickerQuan
        pickerQuan.delegate = self
        pickerQuan.dataSource = self
        loadQuanTP()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func txtTPDidbegin(_ sender: Any) {
        let tp = txtTP.text ?? ""
        if tp == "" {
            pickerTP.selectRow(0, inComponent: 0, animated: true)
            txtTP.text = listTP[0].ten_thanh_pho
            chooseTP = 0
        }
        //pickerTP.selectRow(0, inComponent: 0, animated: true)
    }
    
    @IBAction func txtQuanDidbegin(_ sender: Any) {
        if chooseTP != nil {
            if chooseQuan == nil {
                pickerQuan.selectRow(0, inComponent: 0, animated: true)
                let item = listTP[chooseTP!].quans?[0]
                chooseQuan = 0
                txtQuan.text = item?.ten_quan
            } else {
                
            }
        }
    }
    
    func loadQuanTP() {
        let param : [String : String] = ["session" : self.getSession()]
        Alamofire.request("http://www.giaohangongvang.com/api/khuvuc/get-thanhpho-quan", method: .post, parameters: param).responseJSON { (response) in
            let data = JSON.init(data: response.data!)
            let status = data["status"].stringValue
            if status == "fail" {
                let warning = data["warning"].stringValue
                self.view.makeToast(warning, duration: 2.0, position: .center)
            } else {
                let details = data["detail"].arrayValue
                if details.count != 0 {
                    for item in details {
                        self.listTP.append(TP.init(json: item))
                    }                    
                }
            }
        }
    }
    
    @IBAction func btnXacNhan(_ sender : UIButton){
        let param : [String : String] = ["session" : self.getSession(),
                                         "sdt_nguoi_nhan" : sdt!.toBase64()]
        
        let tp = txtTP.text ?? ""
        let quan = txtQuan.text ?? ""
        if tp == "" {
            self.view.makeToast("Mời chọn Thành Phố", duration: 2.0, position: .center)
            return
        } else if quan == "" {
            self.view.makeToast("Mời chọn quận", duration: 2.0, position: .center)
            return
        }
        let dia_chi_doi = txtDiaChi.text ?? ""
        if dia_chi_doi == "" {
            self.view.makeToast("Nhập địa chỉ", duration: 2.0, position: .center)
            return
        }
        self.showLoadingHUD()
        Alamofire.request("http://www.giaohangongvang.com/api/donhang/create-donhang-sdt", method: .post, parameters: param).responseJSON { (response) in
            let data = JSON.init(data: response.data!)
            self.hideLoadingHUD()
            NSLog("\(data)")
            let status = data["status"].stringValue
            if status == "success" {
                let a = data["detail"]
                let id = a[0]["id_don_hang"].stringValue
                
                let param2 : [String : String] = ["session" : self.getSession(),
                                                  "id_don_hang" : id.toBase64(),
                                                  "dia_chi_doi" : dia_chi_doi.toBase64(),
                                                  "id_thanh_pho" : self.listTP[self.chooseTP!].id_thanh_pho.toBase64(),
                                                  "id_quan" : (self.listTP[self.chooseTP!].quans?[self.chooseQuan!].id_quan.toBase64())!]
                Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/doi-diachi", method: .post, parameters: param2).responseJSON(completionHandler: { (response) in
                    let data = JSON.init(data: response.data!)
                    NSLog("\(data)")
                    let warning = data["warning"].stringValue
                    NhanDonGiaoViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
                    self.popupController?.dismiss()
                })
            } else {
                let warning = data["warning"].stringValue
                NhanDonGiaoViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
                self.popupController?.dismiss()
            }
        }
    }
    @IBAction func closePopUp() {
        self.popupController?.dismiss()
    }
}
extension DonGIaoMoiViewController : UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case pickerTP:
            return listTP.count
        default:
            if chooseTP == nil {
                return 0
            } else {
                if listTP[chooseTP!].quans == nil {
                    return 0
                } else {
                    return listTP[chooseTP!].quans!.count
                }
            }

        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case pickerTP:
            return listTP[row].ten_thanh_pho
        default:
            return listTP[chooseTP!].quans?[row].ten_quan
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case pickerTP:
            chooseTP = row
            txtTP.text = listTP[row].ten_thanh_pho
        default:
            self.chooseQuan = row
            txtQuan.text = listTP[chooseTP!].quans?[row].ten_quan
        }
    }
}
