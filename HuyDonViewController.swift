//
//  HuyDonViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/11/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HuyDonViewController: BaseViewController {
    @IBOutlet weak var lblDisplay : UILabel!
    @IBOutlet weak var txtLydo : UITextView!
    var list : String = ""
    var nameShop : String = ""
    var count : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupController?.navigationBarHidden = true
        self.contentSizeInPopup  = CGSize(width: 300, height: 300)
        
        self.lblDisplay.text = "Hủy \(count ?? 0) đơn của \(nameShop)"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        txtLydo.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeTouchUp(_ sender : UIButton) {
        ReceiveViewController.shouldLoad = false
        self.popupController?.dismiss()
    }
    
    @IBAction func huydon(_ sender : UIButton) {
        let textLyDo = txtLydo.text ?? ""
        if (textLyDo == "") {
            self.view.makeToast("Nhập lý do", duration: 2.0, position: .center)
            return
        } else {
            let session = self.getSession()
            let ghi_chu = txtLydo.text ?? ""
            let param : [String : String] = ["session" : session,
                                             "ghi_chu" : ghi_chu.toBase64(),
                                             "list" : list.toBase64()]
            Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/huy-don", method: .post, parameters: param).responseJSON(completionHandler: { (response) in
                ReceiveViewController.shouldLoad = true
                let data = JSON.init(data: response.data!)
                let warning = data["warning"].stringValue
                ReceiveViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
                self.popupController?.dismiss()
                NotificationCenter.default.post(Notification(name: Notification.Name.init("UpdateReceive")))                
            })
        }
    }
}
