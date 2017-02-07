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

class HoanThanhViewController: UIViewController {
    let HEIGHT_PRICE : CGFloat = 40
    @IBOutlet weak var heightPriceConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnCoHangHoan : UIButton!
    @IBOutlet weak var btnCoGuiXe : UIButton!
    @IBOutlet weak var lblThucThu : UITextField!
    @IBOutlet weak var lblGuiXe : UITextField!
    @IBOutlet weak var lblGhiChu : UITextView!
    var item : DeliveryObject?
    var boolguixe : Bool = false
    
    var isCoHangHoan : Bool = false
    var isCoGuiXe : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.popupController?.navigationBar.backgroundColor = UIColor.init(rgba: "#EBB003")
        self.popupController?.navigationBarHidden = true
        self.contentSizeInPopup  = CGSize(width: 300, height: 300 - HEIGHT_PRICE)
        self.landscapeContentSizeInPopup = CGSize(width: 300, height: 300 - 40)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closePopUp(_ sender : UIButton){
        self.popupController?.dismiss()
    }
    
    @IBAction func doneTouchUp(_ sender : UIButton){
        let session = UserDefaults.standard.value(forKey: UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.session)) as! String
        let id_don_hang = "\(item?.id_don_hang)"
        var co_hang_hoan = ""
        if isCoHangHoan {
            co_hang_hoan = "true"
        } else {
            co_hang_hoan = "false"
        }
        let thuc_thu = lblThucThu.text ?? ""
        let gui_xe = lblGuiXe.text ?? ""
        let ghi_chu = lblGhiChu.text ?? ""
        let param : [String : String] = ["session" : session.toBase64() ,
                                         "id_don_hang" : id_don_hang.toBase64() ,
                                         "co_hang_hoan" : co_hang_hoan.toBase64() ,
                                         "thuc_thu" : thuc_thu.toBase64() ,
                                         "gui_xe" : gui_xe.toBase64(),
                                         "ghi_chu" : ghi_chu.toBase64()
        ]
        Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/hoan-thanh-don", method: .post, parameters: param).responseJSON { (response) in
            let json = JSON.init(data: response.data!)
            NSLog("\(json)")
            let warning = json["warning"].stringValue
            DeliveryViewController.sharedInstance.view.makeToast(warning, duration: 2, position: .center)
            self.popupController?.dismiss()
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
    
    @IBAction func coguixe(_ sender : UIButton){
        isCoGuiXe = !isCoGuiXe
        if isCoGuiXe {
            btnCoGuiXe.setImage(UIImage.init(named: "checked"), for: UIControlState.normal)
            heightPriceConstraint.constant = HEIGHT_PRICE
            self.contentSizeInPopup = CGSize(width: 300, height: 300)
        } else {
            btnCoGuiXe.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
            heightPriceConstraint.constant = 0
            self.contentSizeInPopup = CGSize(width: 300, height: 300 - HEIGHT_PRICE)
        }
    }
}
