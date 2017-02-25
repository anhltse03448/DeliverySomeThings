//
//  DoiDiaChiViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/10/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DoiDiaChiViewController: BaseViewController {
    var dov : DeliveryObject?
    @IBOutlet weak var lblDCCu : UILabel!
    @IBOutlet weak var txtTp : UITextField!
    @IBOutlet weak var txtQuan : UITextField!
    @IBOutlet weak var txtDCNhap : UITextView!
    
    var pickerTP = UIPickerView()
    var pickerQuan = UIPickerView()
    var listTP = [TP]()
    var chooseTP : Int?
    var id_quan : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupController?.navigationBarHidden = true
        self.contentSizeInPopup  = CGSize(width: 300, height: 300)
        
        txtTp.inputView = pickerTP
        txtQuan.inputView = pickerQuan
        
        pickerQuan.dataSource = self
        pickerTP.dataSource = self
        
        pickerTP.delegate = self
        pickerQuan.delegate = self
        
        self.loadQuanTP()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.lblDCCu.text = dov?.dia_chi_nguoi_nhan
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doiDCTouchUp(_ sender : UIButton) {
        DeliveryViewController.shouldLoad = true
        let dcdoi = txtDCNhap.text ?? ""
        let id_don_hang = dov?.id_don_hang ?? ""
        if id_quan == "" {
            self.view.makeToast("Chọn quận", duration: 2.0, position: .center)
            return
        }
        let param : [String : String] = ["session" : self.getSession(),
                                         "id_don_hang" : id_don_hang.toBase64(),
                                         "dia_chi_doi" : dcdoi.toBase64(),
                                         "id_thanh_pho" : "\(chooseTP!)".toBase64(),
                                         "id_quan" :  id_quan.toBase64()]
        Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/doi-diachi", method: .post, parameters: param).responseJSON { (response) in
            DeliveryViewController.shouldLoad = true
            let data = JSON.init(data: response.data!)
            let warning = data["warning"].stringValue
            DeliveryViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
            self.popupController?.dismiss()
            
        }
    }
    
    @IBAction func closeTouchUp(_ sender : UIButton) {
        DeliveryViewController.shouldLoad = false
        self.popupController?.dismiss()
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
                    for item in self.listTP {
                        if item.id_thanh_pho == self.dov?.id_thanhpho_gui {
                            self.chooseTP = self.listTP.index(of: item)!
                            self.pickerTP.selectRow(self.chooseTP!, inComponent: 0, animated: true)
                            self.txtTp.text = self.listTP[self.chooseTP!].ten_thanh_pho
                        }
                    }
                }
            }
        }
    }
}
extension DoiDiaChiViewController : UIPickerViewDataSource,UIPickerViewDelegate {
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
            txtTp.text = listTP[row].ten_thanh_pho
        default:
            txtQuan.text = listTP[chooseTP!].quans?[row].ten_quan
            id_quan = (listTP[chooseTP!].quans?[row].id_quan)!
        }
    }
}

