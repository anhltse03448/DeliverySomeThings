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

class HoanThanhViewController: UIViewController {
    let HEIGHT_PRICE : CGFloat = 40
    @IBOutlet weak var heightPriceConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnCoHangHoan : UIButton!
    @IBOutlet weak var btnCoGuiXe : UIButton!
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
        let session = ""
        let id_don_hang = ""
        let co_hang_hoan = ""
        let thuc_thu = ""
        let gui_xe = ""
        let ghi_chu = ""
        let param : [String : String] = ["session" : session ,
                                         "id_don_hang" : id_don_hang ,
                                         "co_hang_hoan" : co_hang_hoan ,
                                         "thuc_thu" : thuc_thu ,
                                         "gui_xe" : gui_xe,
                                         "ghi_chu" : ghi_chu
        ]
        Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/hoan-thanh-don", method: .post, parameters: param).responseJSON { (response) in
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
