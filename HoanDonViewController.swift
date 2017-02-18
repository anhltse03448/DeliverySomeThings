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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentSizeInPopup  = CGSize(width: 300, height: 500)
        self.landscapeContentSizeInPopup = CGSize(width: 300, height: 300)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismisKeyboard(_:))))
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.popupController?.navigationBarHidden = true
    }
    
    @IBAction func btnLyDoTouchUp(_ sender : UIButton) {
        let tag = sender.tag
        var str = ""
        switch tag {
        case 0:
            str = "Người nhận xem hàng từ chối nhận sản phẩm"
            heightMoney.constant = 0
        case 1:
            str = "Người nhận báo sản phẩm lỗi"
            heightMoney.constant = 0
        case 2:
            str = "Người nhận báo nhầm sản phẩm"
            heightMoney.constant = 0
        case 3:
            str = "Người nhận hẹn tới nơi không liên lạc được người nhận"
            heightMoney.constant = 0
        case 4:
            str = "Người nhận báo hủy qua điện thoại"
            heightMoney.constant = 30
        case 5:
            str = "3 ngày không liên hệ được người nhận"
            heightMoney.constant = 30
        case 6:
            str = "Người nhận đổi địa chỉ, giờ giao ngoài thời gian phục vụ"
            heightMoney.constant = 30
        case 7:
            str = "Người nhận hẹn giao nhiều lần nhưng chưa nhận hàng"
            heightMoney.constant = 30
        default:
            str =  "Shop báo hủy"
            heightMoney.constant = 30
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
        let id_don_hang = dov?.id_don_hang
        var ghi_chu = txtGhiChu.text ?? ""
        let height = heightMoney.constant
        let moneyA  = money.text ?? ""
        var isHoanCuoc = "true"
        if ghi_chu != "" {
            if height != 0 {
                isHoanCuoc = "true"
                if moneyA == "" {
                    self.view.makeToast("Mời nhập tiền", duration: 2.0, position: .center)
                    return
                } else {
                    ghi_chu = ghi_chu + " Nguoi nhan TT : \(moneyA)d"
                }
            } else {
                isHoanCuoc = "false"
                
            }
            let param : [String : String] = ["session" : self.getSession(),
                                             "id_don_hang": (id_don_hang?.toBase64())!,
                                             "hoan_co_cuoc" : isHoanCuoc.toBase64(),
                                             "nguoi_nhan_thanh_toan_cuoc" : moneyA.toBase64(),
                                             "ghi_chu" : ghi_chu.toBase64()]
            Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/ghichu", method: .post, parameters: param).responseJSON { (response) in
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
}
