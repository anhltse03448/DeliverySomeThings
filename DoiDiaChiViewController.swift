//
//  DoiDiaChiViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/10/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

class DoiDiaChiViewController: UIViewController {
    var dov : DeliveryObject?
    @IBOutlet weak var lblDCCu : UILabel!
    @IBOutlet weak var txtTp : UITextField!
    @IBOutlet weak var txtQuan : UITextField!
    @IBOutlet weak var txtDCNhap : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupController?.navigationBarHidden = true
        self.contentSizeInPopup  = CGSize(width: 300, height: 300)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.lblDCCu.text = dov?.dia_chi_nguoi_nhan
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doiDCTouchUp(_ sender : UIButton) {
        
    }
    
    @IBAction func closeTouchUp(_ sender : UIButton) {
        self.popupController?.dismiss()
    }
}
