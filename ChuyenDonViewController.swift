//
//  ChuyenDonViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/11/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class ChuyenDonViewController: BaseViewController {
    var list : String = ""
    var count : Int?
    var nameShop : String = ""
    @IBOutlet weak var txtNV : UITextField!
    @IBOutlet weak var lydo : UITextView!
    @IBOutlet weak var lblShow : UILabel!
    var listNV = [NhanVien]()
    var nhanVienChon : String = ""
    var pickerNV = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupController?.navigationBarHidden = true
        self.contentSizeInPopup = CGSize(width: 300, height: 300)
        lblShow.text = "Chuyển \(count ?? 0) đơn hàng của \(nameShop) "
        setInputView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.requestNhanVien()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestChuyenDon() {
        let session = self.getSession()
        let id_nhan_vien_chuyen = self.nhanVienChon
        let ghi_chu = lydo.text ?? ""
        if ghi_chu == "" {
            self.view.makeToast("Nhập ghi chú", duration: 2.0, position: .center)
            return
        } else if id_nhan_vien_chuyen == "" {
            self.view.makeToast("Chọn Nhân viên", duration: 2.0, position: .center)
            return
        }
        else {
            let param : [String : String] = ["session" : session,
                                             "id_nhan_vien_chuyen" : id_nhan_vien_chuyen.toBase64(),
                                             "ghi_chu" : ghi_chu.toBase64(),
                                             "list" : list.toBase64()]
            
            Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/chuyen-don", method: .post, parameters: param).responseJSON { (response) in
                ReceiveViewController.shouldLoad = true
                self.popupController?.dismiss()
                let data = JSON.init(data: response.data!)
                let warning = data["warning"].stringValue
                ReceiveViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
                NotificationCenter.default.post(Notification(name: Notification.Name.init("UpdateReceive")))
                
            }
        }
    }
    
    func requestNhanVien() {
        let session = self.getSession()
        let param : [String : String] = ["session" : session]
        Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/list-nhanvien", method: .post, parameters: param).responseJSON { (response) in
            if response.data != nil {
                let data = JSON.init(data: response.data!)
                let dta = data["detail"].array
                if dta != nil {
                    for item in dta! {
                        self.listNV.append(NhanVien(json: item))
                    }
                } else {
                    let warning = data["warning"].stringValue
                    ReceiveViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
                }
            }
        }
    }
    
    func setInputView() {
        
        pickerNV.dataSource = self
        pickerNV.delegate = self
        txtNV.inputView = pickerNV
    }
    
    @IBAction func chuyenDonTouchUp(_ sender : UIButton) {
        requestChuyenDon()
    }
    
    @IBAction func closeTouchUp(_ sender : UIButton) {
        ReceiveViewController.shouldLoad = false
        self.popupController?.dismiss()
    }
    @IBAction func nhanVienDidBegin(_ sender: Any) {
        if self.nhanVienChon == "" {
            pickerNV.selectRow(0, inComponent: 0, animated: true)
            self.nhanVienChon = listNV[0].id_nhan_vien
            txtNV.text = listNV[0].ho_ten
        }
    }
}
extension ChuyenDonViewController : UIPickerViewDataSource , UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listNV.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listNV[row].ho_ten
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtNV.text = listNV[row].ho_ten
        self.nhanVienChon = listNV[row].id_nhan_vien
    }
}
