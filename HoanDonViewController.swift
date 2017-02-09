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

class HoanDonViewController: UIViewController {
    @IBOutlet weak var txtGhiChu : UITextView!
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
        case 1:
            str = "Người nhận báo sản phẩm lỗi"
        case 2:
            str = "Người nhận báo nhầm sản phẩm"
        case 3:
            str = "Người nhận hẹn tới nơi không liên lạc được người nhận"
        case 4:
            str = "Người nhận báo hủy qua điện thoại"
        case 5:
            str = "3 ngày không liên hệ được người nhận"
        case 6:
            str = "Người nhận đổi địa chỉ, giờ giao ngoài thời gian phục vụ"
        case 7:
            str = "Người nhận hẹn giao nhiều lần nhưng chưa nhận hàng"
        default:
            str =  "Shop báo hủy"
        }
        txtGhiChu.text = str
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func close(_ sender : UIButton) {
        self.popupController?.dismiss()
    }
    
    @IBAction func hoandonTouchUp(_ sender : UIButton){
        let param : [String : String] = ["" : ""]
        Alamofire.request("", method: .post, parameters: param).responseJSON { (response) in
            
        }
    }
    func dismisKeyboard(_ gesture : UITapGestureRecognizer) {
        txtGhiChu.resignFirstResponder()
    }
}
