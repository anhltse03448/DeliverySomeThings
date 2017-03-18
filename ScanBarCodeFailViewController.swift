//
//  ScanBarCodeFailViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 3/18/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import STPopup

class ScanBarCodeFailViewController: UIViewController {
    @IBOutlet weak var lblDonHangID: UILabel!
    var idDonHang : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupController?.navigationBarHidden = true
        self.contentSizeInPopup  = CGSize(width: 300, height: 120)
        self.lblDonHangID.text = idDonHang
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeTouchUp(_ sender : UIButton) {
        self.popupController?.dismiss()
    }
}
