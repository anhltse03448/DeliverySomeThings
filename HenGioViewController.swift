//
//  HenGioViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/8/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HenGioViewController: UIViewController {
    @IBOutlet weak var txtNgay : UITextField!
    @IBOutlet weak var txtGio : UITextField!
    var dov : DeliveryObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupController?.navigationBarHidden = true
        self.contentSizeInPopup  = CGSize(width: 300, height: 150)        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeTouchUp(_ sender : UIButton) {
        self.popupController?.dismiss()
    }
    @IBAction func datHenTouchUp(_ sender : UIButton) {
        let session = UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.session)
        let id_don_hang = dov?.id_don_hang ?? ""
        let ngay_hen = txtNgay.text ?? ""
        let gio_hen = txtGio.text ?? ""
        if (ngay_hen != "") && (gio_hen != "") {
            let param : [String : String] = ["session" : session.toBase64(),
                                             "id_don_hang" : id_don_hang,
                                             "ngay_hen" : ngay_hen.toBase64(),
                                             "gio_hen":gio_hen.toBase64()]
            Alamofire.request("", method: .post, parameters: param).response(completionHandler: { (response) in
                let data = JSON.init(data: response.data!)
                let warning = data["warning"].stringValue
                GhiChuViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
                self.popupController?.dismiss()
            })
        }
    }
    
    @IBAction func dp(sender: UITextField) {
        
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(HenGioViewController.handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @IBAction func hp(sender: UITextField) {
        
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(HenGioViewController.handleTimePicker(sender:)), for: .valueChanged)
    }
    
    func handleTimePicker (sender : UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        txtGio.text = dateFormatter.string(from: sender.date)
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        txtNgay.text = dateFormatter.string(from: sender.date)
    }
    func dismisKeyboard(_ gesture : UITapGestureRecognizer) {
        txtNgay.resignFirstResponder()
        txtGio.resignFirstResponder()
    }
}
