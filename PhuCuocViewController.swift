//
//  PhuCuocViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/18/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PhuCuocViewController: BaseViewController {
    @IBOutlet weak var txtTaiTrong : UITextField!
    @IBOutlet weak var txtDai : UITextField!
    @IBOutlet weak var txtRong : UITextField!
    @IBOutlet weak var txtCao : UITextField!
    var dov : DeliveryObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupController?.navigationBarHidden = true
        self.contentSizeInPopup  = CGSize(width: 300, height: 170)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.popupController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCloseTouchUp(_ sender : UIButton) {
        DeliveryViewController.shouldLoad = false
        self.popupController?.dismiss()
    }
    @IBAction func btnDoneTouchUp(_ sender : UIButton){
        DeliveryViewController.shouldLoad = true
        let taitrong = txtTaiTrong.text ?? ""
        if taitrong == "" {
            self.view.makeToast("Nhập tải trọng", duration: 2.0, position: .center)
            return
        }
        let dai = txtDai.text ?? ""
        if dai == "" {
            self.view.makeToast("Nhập dài", duration: 2.0, position: .center)
            return
        }
        let rong = txtRong.text ?? ""
        if rong == "" {
            self.view.makeToast("Nhập rộng", duration: 2.0, position: .center)
            return
        }
        
        let cao = txtCao.text ?? ""
        if cao == "" {
            self.view.makeToast("Nhập cao", duration: 2.0, position: .center)
            return
        }
        
        let param : [String : String] = ["session" : self.getSession(),
                                         "id" : (dov?.id_don_hang.toBase64())!,
                                         "weight": taitrong.toBase64(),
                                         "size" : "\(dai)x\(rong)x\(cao)".toBase64()]
        Alamofire.request("http://www.giaohangongvang.com/api/dieuvan/sua-can-kich", method: .post, parameters: param).responseJSON { (response) in
            let data = JSON.init(data: response.data!)
            let warning = data["warning"].stringValue
            DeliveryViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
            DeliveryViewController.shouldLoad = true
            self.popupController?.dismiss(completion: { 
                
            })
        }
    }
}
