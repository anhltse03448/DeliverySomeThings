//
//  RegisterViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/20/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var btnNext : UIButton!
    @IBOutlet weak var img_back : UIImageView!
    @IBOutlet weak var txtName : UITextField!
    @IBOutlet weak var txtNumberPhone : UITextField!
    @IBOutlet weak var txtAddress : UITextField!
    @IBOutlet weak var txtCMND : UITextField!
    @IBOutlet weak var txtNgayCap : UITextField!
    var frameOrigin : CGRect?
    var heightKeyboard : CGFloat = 300
    override func viewDidLoad() {
        super.viewDidLoad()
        img_back.isUserInteractionEnabled = true
        img_back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.back_touchUp(_:))))
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismisKeyboard(_:))))
        
        let ViewForDoneButtonOnKeyboard = UIToolbar()
        ViewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .bordered, target: self, action: #selector(self.dismisKeyboard(_:)))
        ViewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
        txtName.inputAccessoryView = ViewForDoneButtonOnKeyboard
        txtNumberPhone.inputAccessoryView = ViewForDoneButtonOnKeyboard
        txtAddress.inputAccessoryView = ViewForDoneButtonOnKeyboard
        txtCMND.inputAccessoryView = ViewForDoneButtonOnKeyboard
        txtNgayCap.inputAccessoryView = ViewForDoneButtonOnKeyboard
 
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: .UIKeyboardDidShow , object: nil)
        
//        myTextField.inputAccessoryView = ViewForDoneButtonOnKeyboard
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if frameOrigin == nil {
            frameOrigin = self.view.frame
        }
    }
    
    func keyboardDidShow(_ notification: NSNotification) {
        print("Keyboard will show!")
        // print(notification.userInfo)
        
        let keyboardSize:CGSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        let height = min(keyboardSize.height, keyboardSize.width)
        heightKeyboard = height
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func keyBoardShow( sender : UITextField) {
        var frame = self.view.frame
//        NSLog("\(sender.frame.origin.y)")
//        
//        frame.origin.y = frame.origin.y - heightKeyboard
//        self.view.frame = frame
    }
    
    @IBAction func txtNgayCapDidChange(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        //datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        datePickerView.addTarget(self, action: #selector(RegisterViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        var frame = self.view.frame
        frame.origin.y = frame.origin.y - heightKeyboard
        self.view.frame = frame
    }
    
    func dismisKeyboard(_ gesture : UITapGestureRecognizer) {
        self.view.frame = frameOrigin!
        txtName.resignFirstResponder()
        txtNumberPhone.resignFirstResponder()
        txtAddress.resignFirstResponder()
        txtCMND.resignFirstResponder()
        txtNgayCap.resignFirstResponder()
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        
        dateFormatter.timeStyle = .none
        
        txtNgayCap.text = dateFormatter.string(from: sender.date)
        
    }
    
    func back_touchUp(_ gesture : UITapGestureRecognizer) {
        self.dismiss(animated: true) { 
            
        }
    }
    
    @IBAction func btnNextTouchUpInsde( _ sender : Any) {
        let regis2VC = RegisInforFamilyViewController(nibName: "RegisInforFamilyViewController", bundle: nil)
        self.navigationController?.pushViewController(regis2VC, animated: true)
    }
}
extension RegisterViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
