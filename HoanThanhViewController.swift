//
//  HoanThanhViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/25/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import STPopup
import Alamofire
import SwiftyJSON

class HoanThanhViewController: BaseViewController {
    let HEIGHT_PRICE : CGFloat = 40
    @IBOutlet weak var heightPriceConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnCoHangHoan : UIButton!
    @IBOutlet weak var btnCoGuiXe : UIButton!
    @IBOutlet weak var lblThucThu : UITextField!
    @IBOutlet weak var lblGuiXe : UITextField!
    @IBOutlet weak var lblGhiChu : UITextView!
    @IBOutlet weak var lblThuHo : UILabel!
    var item : DeliveryObject?
    var boolguixe : Bool = false
    
    var isCoHangHoan : Bool = false
    var isCoGuiXe : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.popupController?.navigationBar.backgroundColor = UIColor.init(rgba: "#EBB003")        
        self.contentSizeInPopup  = CGSize(width: 300, height: 390 - HEIGHT_PRICE)
        self.landscapeContentSizeInPopup = CGSize(width: 300, height: 390 - HEIGHT_PRICE)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.popupController?.navigationBarHidden = true
        lblThuHo.text = Int((item?.cod)!)?.stringFormattedWithSeparator
        lblThucThu.text = Int((item?.cod)!)?.stringFormattedWithSeparator
        //lblGuiXe.text = Int(item?)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closePopUp(_ sender : UIButton){
        DeliveryViewController.shouldLoad = false
        self.popupController?.dismiss()
    }
    
    @IBAction func doneTouchUp(_ sender : UIButton){
        let id_don_hang = item?.id_don_hang
        var co_hang_hoan = ""
        if isCoHangHoan {
            co_hang_hoan = "true"
        } else {
            co_hang_hoan = "false"
        }
        var thuc_thu = lblThucThu.text ?? ""
        thuc_thu = thuc_thu.replacingOccurrences(of: ",", with: "")
        let gui_xe = lblGuiXe.text ?? ""
        var ghi_chu = lblGhiChu.text ?? ""
        if ghi_chu == "" {
            if isCoHangHoan {
                self.view.makeToast("Nhập ghi chú", duration: 2.0, position: .center)
                return
            }
        }
        
        let txtThuHo = lblThuHo.text?.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " ", with: "")
        if thuc_thu != txtThuHo {
            if ghi_chu == "" {
                self.view.makeToast("Nhập ghi chú", duration: 2.0, position: .center)
                return
            }
        }
        
        if isCoGuiXe {
            ghi_chu = ghi_chu + "gui xe: \(gui_xe)"
        }
        let param : [String : String] = ["session" : self.getSession() ,
                                         "id_don_hang" : id_don_hang!.toBase64() ,
                                         "co_hang_hoan" : co_hang_hoan.toBase64() ,
                                         "thuc_thu" : thuc_thu.toBase64() ,
                                         "gui_xe" : gui_xe.toBase64(),
                                         "ghi_chu" : ghi_chu.toBase64()
        ]
        
        if isCoGuiXe {
            if gui_xe == "" {
                self.view.makeToast("Nhập tiền gửi xe", duration: 2.0, position: .center)
                return
            }
        }
        
        Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/hoan-thanh-don", method: .post, parameters: param).responseJSON { (response) in
            DeliveryViewController.shouldLoad = true
            if response.data != nil {
                let json = JSON.init(data: response.data!)
                NSLog("\(json)")
                let warning = json["warning"].stringValue
                DeliveryViewController.sharedInstance.view.makeToast(warning, duration: 2, position: .center)
                self.popupController?.dismiss()
            } else {
                self.popupController?.dismiss()
            }
        }
    }
    
    @IBAction func cohanghoanTouchUp(_ sender : UIButton){
        isCoHangHoan = !isCoHangHoan
        if isCoHangHoan {
            btnCoHangHoan.setImage(UIImage.init(named: "checked"), for: UIControlState.normal)
        } else {
            btnCoHangHoan.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        }
    }
    
    @IBAction func thucThuDidChange(_ sender: Any) {
        let txt = lblThucThu.text
        let txtConvert = txt?.replacingOccurrences(of: ",", with: "")
        if txtConvert != nil {
            if txtConvert != "" {
                lblThucThu.text = Int(txtConvert!)?.stringFormattedWithSeparator
            }
        }
    }
    
    @IBAction func guixeDidChange(_ sender: Any) {
        let txt = lblGuiXe.text
        let txtConvert = txt?.replacingOccurrences(of: ",", with: "")
        if txtConvert != nil {
            if txtConvert != "" {
                lblGuiXe.text = Int(txtConvert!)?.stringFormattedWithSeparator
            }
        }
    }
    @IBAction func coguixe(_ sender : UIButton){
        isCoGuiXe = !isCoGuiXe
        if isCoGuiXe {
            btnCoGuiXe.setImage(UIImage.init(named: "checked"), for: UIControlState.normal)
            heightPriceConstraint.constant = HEIGHT_PRICE
            self.contentSizeInPopup = CGSize(width: 300, height: 390)
        } else {
            btnCoGuiXe.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
            heightPriceConstraint.constant = 0
            self.contentSizeInPopup = CGSize(width: 300, height: 390 - HEIGHT_PRICE)
        }
    }
}
