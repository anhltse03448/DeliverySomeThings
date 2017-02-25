//
//  HoanDonViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/25/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import ToastSwiftFramework
import SwiftyJSON

class HoanDonViewController: BaseViewController {
    @IBOutlet weak var heightMoney: NSLayoutConstraint!
    @IBOutlet weak var txtGhiChu : UITextView!
    @IBOutlet weak var money : UITextField!
    var dov : DeliveryObject?
    private var id_huy_don : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentSizeInPopup  = CGSize(width: 300, height: 500 + 30)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismisKeyboard(_:))))
        id_huy_don = "1"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.popupController?.navigationBarHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        id_huy_don = "1"
    }
    
    @IBAction func btnLyDoTouchUp(_ sender : UIButton) {
        let tag = sender.tag
        var str = ""
        switch tag {
        case 0:
            str = "Người nhận xem hàng từ chối nhận sản phẩm"
            self.contentSizeInPopup  = CGSize(width: 300, height: 500 + 30)
            heightMoney.constant = 30
            id_huy_don = "2"
        case 1:
            str = "Người nhận báo sản phẩm lỗi"
            self.contentSizeInPopup  = CGSize(width: 300, height: 500 + 30)
            heightMoney.constant = 30
            id_huy_don = "3"
        case 2:
            str = "Người nhận báo nhầm sản phẩm"
            self.contentSizeInPopup  = CGSize(width: 300, height: 500 + 30)
            heightMoney.constant = 30
            id_huy_don = "4"
        case 3:
            str = "Người nhận hẹn tới nơi không liên lạc được người nhận"
            self.contentSizeInPopup  = CGSize(width: 300, height: 500 + 30)
            heightMoney.constant = 30
            id_huy_don = "5"
        case 4:
            str = "Người nhận báo hủy qua điện thoại"
            self.contentSizeInPopup  = CGSize(width: 300, height: 500)
            heightMoney.constant = 0
            id_huy_don = "6"
        case 5:
            str = "3 ngày không liên hệ được người nhận"
            self.contentSizeInPopup  = CGSize(width: 300, height: 500 )
            heightMoney.constant = 0
            id_huy_don = "7"
        case 6:
            str = "Người nhận đổi địa chỉ, giờ giao ngoài thời gian phục vụ"
            self.contentSizeInPopup  = CGSize(width: 300, height: 500 )
            heightMoney.constant = 0
            id_huy_don = "8"
        case 7:
            str = "Người nhận hẹn giao nhiều lần nhưng chưa nhận hàng"
            self.contentSizeInPopup  = CGSize(width: 300, height: 500 )
            heightMoney.constant = 0
            id_huy_don = "9"
        case 8:
            str =  "Shop báo hủy"
            self.contentSizeInPopup  = CGSize(width: 300, height: 500 )
            heightMoney.constant = 0
            id_huy_don = "10"
        default:
            str = "Khác"
            self.contentSizeInPopup  = CGSize(width: 300, height: 500 + 30)
            heightMoney.constant = 30
            id_huy_don = "1"
        }
        txtGhiChu.text = str
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func close(_ sender : UIButton) {
        DeliveryViewController.shouldLoad = false
        self.popupController?.dismiss()
    }
    
    @IBAction func hoandonTouchUp(_ sender : UIButton){
        DeliveryViewController.shouldLoad = true
        let id_don_hang = dov?.id_don_hang
        var ghi_chu = txtGhiChu.text ?? ""
        let height = heightMoney.constant
        var moneyA  = money.text ?? ""
        moneyA = moneyA.replacingOccurrences(of: ",", with: "")
        var isHoanCuoc = "true"
        if ghi_chu != "" {
            if height != 0 {
                isHoanCuoc = "true"
//                if moneyA == "" {
//                    self.view.makeToast("Mời nhập tiền", duration: 2.0, position: .center)
//                    return
//                } else {
//                    ghi_chu = ghi_chu + " Nguoi nhan TT : \(moneyA)d"
//                }
            } else {
                isHoanCuoc = "false"
                
            }
            let param : [String : String] = ["session" : self.getSession(),
                                             "id_don_hang": (id_don_hang?.toBase64())!,
                                             "hoan_co_cuoc" : isHoanCuoc.toBase64(),
                                             "nguoi_nhan_thanh_toan_cuoc" : moneyA.toBase64(),
                                             "ghi_chu" : ghi_chu.toBase64(),
                                             "id_huy_don" : "\(id_huy_don)".toBase64()]
            Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/hoan-don", method: .post, parameters: param).responseJSON { (response) in
                DeliveryViewController.shouldLoad = true
                if response.data != nil {
                    let json = JSON.init(data: response.data!)
                    let warning = json["warning"].string ?? ""
                    DeliveryViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
                    self.popupController?.dismiss()
                } else {
                    self.popupController?.dismiss()
                }
            }
        } else {
            self.view.makeToast("Mời nhập ghi chú", duration: 2.0, position: .center)
        }
    }
    func dismisKeyboard(_ gesture : UITapGestureRecognizer) {
        txtGhiChu.resignFirstResponder()
    }
    @IBAction func txtTTChange(_ sender: Any) {
        var txt = money.text ?? ""
        txt = txt.replacingOccurrences(of: ",", with: "")
        txt = txt.stringFormattedWithSeprator
        money.text = txt
    }
}
