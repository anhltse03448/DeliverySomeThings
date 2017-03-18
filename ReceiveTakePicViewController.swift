//
//  ReceiveTakePicViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/21/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import STPopup
class NguoiGui : NSObject {
    /*
     "id_khachhang":"3",
     "id_nguoi_gui":32,
     "ten_nguoi_gui":"dsdssds",
     "sdt_nguoi_gui":"0132158133",
     "diachi":"119 Tây Sơn-Hoàn Kiếm-Hà Nội"
     */
    var id_khachhang : String
    var ten_nguoi_gui : String
    var id_nguoi_gui : String
    var sdt_nguoi_gui : String
    var diachi : String
    init(json : JSON) {
        self.id_khachhang = json["id_khachhang"].stringValue
        self.ten_nguoi_gui = json["ten_nguoi_gui"].stringValue
        self.id_nguoi_gui = json["id_nguoi_gui"].stringValue
        self.sdt_nguoi_gui = json["sdt_nguoi_gui"].stringValue
        self.diachi = json["diachi"].stringValue
    }
    override init() {
        self.id_khachhang = "a"
        self.ten_nguoi_gui = "a"
        self.id_nguoi_gui = "a"
        self.sdt_nguoi_gui = "a"
        self.diachi = "a"
    }
}

class ReceiveTakePicViewController: BaseViewController {
    static let sharedInstance = ReceiveTakePicViewController()
    @IBOutlet weak var TxtName : UITextField!
    @IBOutlet weak var Txtstore : UITextField!
    @IBOutlet weak var txtNumber : UITextField!
    @IBOutlet weak var btnConfirm : UIButton!
    //@IBOutlet weak var chonNhanVien : UITextField!
    var nhanVienChon : String = ""
    var pickerStore = UIPickerView()
    var listNV = [NguoiGui]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestNguoiGui()
        NotificationCenter.default.addObserver(self, selector: #selector(ReceiveTakePicViewController.receinotify(notify:)), name: NSNotification.Name.init("ChooseShop"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    func receinotify(notify : Notification) {
        let obj = notify.object as! [String : String]
        let name = obj["name"] ?? ""
        self.Txtstore.text = name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmTouchUp(_ sender : UIButton) {
        let store = Txtstore.text ?? ""
        let num = txtNumber.text ?? ""
        let name = TxtName.text ?? ""
        if name == "" {
            self.view.makeToast("Nhập tên người gửi", duration: 2.0, position: .center)
            return
        }
        if store == "" {
            self.view.makeToast("Chưa nhập cửa hàng", duration: 2.0, position: .center)
            return
        } else if num == "" {
            self.view.makeToast("Chưa nhập số lượng", duration: 2.0, position: .center)
            return
        }
//        } else if self.nhanVienChon == "" {
////            self.view.makeToast("Chọn nhân viên", duration: 2.0, position: .center)
////            return
//        }
        else{
            let num = (txtNumber.text ?? "0")
            let dateformatter = DateFormatter()//yyMMdd_HHmmss
            dateformatter.dateFormat = "yyMMdd_HHmmss"
            let dateTxt = dateformatter.string(from: Date())
            let userInfo : [String : String] = ["numberPic" : num, "Date" : dateTxt , "Shop" : store
                ,"NhanVien" : "\(TxtName.text ?? "")"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TakePicture"), object: userInfo)
        }        
    }
    
    func requestNguoiGui() {
        self.listNV.removeAll()
        let session = self.getSession()
        let param : [String : String] = ["session" : session]
        Alamofire.request("http://www.giaohangongvang.com/api/dieuvan/danh-sach-nguoi-gui", method: .post, parameters: param).responseJSON { (response) in
            if response.data != nil {
                let data = JSON.init(data: response.data!)
                NSLog("\(data)")
                let dta = data["detail"].array
                if dta != nil {
                    for item in dta! {
                        self.listNV.append(NguoiGui(json: item))
                    }
                } else {
                    let warning = data["warning"].stringValue
                    ReceiveViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
                }
            }
        }
    }
   
    @IBAction func CHDidBegin(_ sender: Any) {
        //Txtstore.resignFirstResponde()
        Txtstore.resignFirstResponder()
        TxtName.resignFirstResponder()
        let vc = SearchShopViewController(nibName: "SearchShopViewController", bundle: nil)
        let stpopup = STPopupController(rootViewController: vc)
        stpopup.present(in: self)
    }
    
    @IBAction func TouchInsde(_ sender: Any) {
        //Txtstore.resignFirstResponde()
        Txtstore.resignFirstResponder()
        TxtName.resignFirstResponder()
        let vc = SearchShopViewController(nibName: "SearchShopViewController", bundle: nil)
        let stpopup = STPopupController(rootViewController: vc)
        stpopup.present(in: self)
    }
}

extension ReceiveTakePicViewController : UIPickerViewDataSource , UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listNV.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listNV[row].ten_nguoi_gui
//        return listNV[row].ho_ten
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if listNV.count > row {
            Txtstore.text = listNV[row].ten_nguoi_gui
            self.nhanVienChon = listNV[row].id_nguoi_gui
        }
        
    }
}

