//
//  CallDieuVanViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/11/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

class CallDieuVanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupController?.navigationBarHidden = true
        self.contentSizeInPopup  = CGSize(width: 300, height: 100)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func closeTouchUp(_ sender : UIButton){
        self.popupController?.dismiss()
    }
    
    @IBAction func callDieuVan(_ sender : UIButton) {
        let phone = "0916661523"
        guard let number = URL(string: "telprompt://" + phone) else { return }
        UIApplication.shared.openURL(number)
        //UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
}
