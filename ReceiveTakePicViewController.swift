//
//  ReceiveTakePicViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/21/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

class ReceiveTakePicViewController: UIViewController {
    static let sharedInstance = ReceiveTakePicViewController()
    @IBOutlet weak var TxtName : UITextField!
    @IBOutlet weak var Txtstore : UITextField!
    @IBOutlet weak var txtNumber : UITextField!
    @IBOutlet weak var btnConfirm : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmTouchUp(_ sender : UIButton) {
        let store = Txtstore.text ?? ""
        let num = txtNumber.text ?? ""
        
        if store == "" {
            self.view.makeToast("Chưa nhập cửa hàng", duration: 2.0, position: .center)
        } else if num == "" {
            self.view.makeToast("Chưa nhập số lượng", duration: 2.0, position: .center)
        } else {
            let num = (txtNumber.text ?? "0")
            let userInfo : [String : String] = ["numberPic" : num]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TakePicture"), object: userInfo)
        }        
    }
}
