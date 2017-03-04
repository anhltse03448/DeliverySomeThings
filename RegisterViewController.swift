//
//  RegisterViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/20/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {
    @IBOutlet weak var btnNext : UIButton!
    @IBOutlet weak var img_back : UIImageView!
    @IBOutlet weak var txtName : UITextField!
    @IBOutlet weak var txtNumberPhone : UITextField!
    @IBOutlet weak var txtAddress : UITextField!
    @IBOutlet weak var txtCMND : UITextField!
    @IBOutlet weak var txtNgayCap : UITextField!
    @IBOutlet weak var txtNgaySinh : UITextField!
    @IBOutlet weak var imgPick : UIImageView!
    @IBOutlet weak var txtNoiCap : UITextField!
    
    @IBOutlet weak var btnNam : UIButton!
    @IBOutlet weak var btnNu : UIButton!
    
    var nameOrNu : Bool = true
    
    let imagePicker = UIImagePickerController()
    var dstinh = [String]()
    var file_path : URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dstinh = self.readDsTinh()
        imagePicker.delegate = self
        img_back.isUserInteractionEnabled = true
        img_back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.back_touchUp(_:))))
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismisKeyboard(_:))))
        imgPick.isUserInteractionEnabled = true
        imgPick.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.pickImage(_:))))
        
        btnNam.setImage(UIImage.init(named: "checked"), for: UIControlState.selected)
        btnNu.setImage(UIImage.init(named: "checked"), for: UIControlState.selected)
        
        btnNam.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        btnNu.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        btnNam.isSelected = true
        setPickerView()
        initNextField()
    }
    
    func initNextField() {
        self.txtName.nextField = self.txtNumberPhone
        self.txtNumberPhone.nextField = self.txtAddress
        self.txtAddress.nextField = self.txtNgaySinh
        self.txtNgaySinh.nextField = self.txtCMND
        self.txtCMND.nextField = self.txtNgayCap
    }
    
    func pickImage(_ gesture : UITapGestureRecognizer) {
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
//        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
//        
//        alert.addAction(UIAlertAction(title: "From Camera", style: .default , handler:{ (UIAlertAction)in
//            self.imagePicker.sourceType = .camera
//            self.present(self.imagePicker, animated: true, completion: nil)
//        }))
//        alert.addAction(UIAlertAction(title: "From Gallery", style: .default , handler:{ (UIAlertAction)in
//            
//        }))
//        
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
//            
//        }))
//        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func txtNgayCapDidChange(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(RegisterViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        if txtNgayCap.text == "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            txtNgayCap.text = dateFormatter.string(from: Date())
        }
    }
    
    func dismisKeyboard(_ gesture : UITapGestureRecognizer) {
//        txtName.resignFirstResponder()
//        txtNumberPhone.resignFirstResponder()
//        txtAddress.resignFirstResponder()
//        txtCMND.resignFirstResponder()
//        txtNgayCap.resignFirstResponder()
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtNgayCap.text = dateFormatter.string(from: sender.date)
    }
    
    func back_touchUp(_ gesture : UITapGestureRecognizer) {
        self.dismiss(animated: true) { 
            
        }
    }
    
    @IBAction func btnNextTouchUpInsde( _ sender : Any) {
        var gioitinh = ""
        if btnNam.isSelected {
            gioitinh = "nam"
        } else {
            gioitinh = "nu"
        }
        let name = txtName.text ?? ""
        let sdt = txtNumberPhone.text ?? ""
        let dia_chi = txtAddress.text ?? ""
        let ngay_sinh = txtNgaySinh.text ?? ""
        let cmnd = txtCMND.text ?? ""
        let ngay_cap = txtNgayCap.text ?? ""
        let noi_cap = txtNoiCap.text ?? ""
        
        if file_path == nil {
            self.view.makeToast("chọn ảnh cá nhân", duration: 2.0, position: .center)
            return
        }
        if name == "" {
            self.view.makeToast("Mời nhập tên", duration: 2.0, position: .center)
            return
        } else if sdt == "" {
            self.view.makeToast("Mời nhập số điện thoại", duration: 2.0, position: .center)
            return
        } else if dia_chi == "" {
            self.view.makeToast("Mời nhập địa chỉ", duration: 2.0, position: .center)
            return
        } else if ngay_sinh == "" {
            self.view.makeToast("Mời nhập ngày sinh", duration: 2.0, position: .center)
            return
        } else if cmnd == "" {
            self.view.makeToast("Mời nhập CMND", duration: 2.0, position: .center)
            return
        } else if ngay_cap == "" {
            self.view.makeToast("Mời nhập ngày cấp", duration: 2.0, position: .center)
            return
        } else if noi_cap == "" {
            self.view.makeToast("Mời nhập nơi cấp", duration: 2.0, position: .center)
            return
        }
        
        let param : [String : String] = ["name" : name,
                                         "gioitinh" : gioitinh,
                                         "sdt" : sdt,
                                         "dia_chi" : dia_chi,
                                         "ngay_sinh" : ngay_sinh,
                                         "cmnd" : cmnd,
                                         "ngay_cap" : ngay_cap,
                                         "noi_cap" : noi_cap,
                                         "file_path" : ""]
        let regis2VC = RegisInforFamilyViewController(nibName: "RegisInforFamilyViewController", bundle: nil)
        regis2VC.fileName = self.file_path
        regis2VC.param = param
        self.navigationController?.pushViewController(regis2VC, animated: true)
    }
    
    @IBAction func dp(sender: UITextField) {
        
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(RegisterViewController.handleDatePicker(sender:)), for: UIControlEvents.valueChanged)
        if txtNgaySinh.text == "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            txtNgaySinh.text = dateFormatter.string(from: Date())
        }
    }
    
    func setPickerView() {
        
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        txtNoiCap.inputView = pickerView
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtNgaySinh.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func namTouchUp(_ sender : UIButton) {
        nameOrNu = true
        btnNam.isSelected = true
        btnNu.isSelected = false
    }
    
    @IBAction func nuTouchUp(_ sender : UIButton) {
        nameOrNu = false
        btnNam.isSelected = false
        btnNu.isSelected = true
    }
}
extension RegisterViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtName:
            txtNumberPhone.becomeFirstResponder()
        case txtNumberPhone:
            txtAddress.becomeFirstResponder()
        case txtAddress:
            txtNgaySinh.becomeFirstResponder()
        case txtNgaySinh:
            txtCMND.becomeFirstResponder()
        case txtCMND:
            txtNgayCap.becomeFirstResponder()
        case txtNgayCap:
            txtNoiCap.becomeFirstResponder()
        default:
            break
        }
        return true
    }
}
extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        NSLog("\(info)")
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imgPick.image = pickedImage
            let data = UIImageJPEGRepresentation(pickedImage, 1)
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dataPath = documentsDirectory.appendingPathComponent("GHOV/REGIS")
            do {
                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
                let filename = dataPath.appendingPathComponent("self.png")
                self.file_path = filename
                try? data?.write(to: filename)
            } catch let error as NSError {
                
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
extension RegisterViewController : UIPickerViewDataSource , UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dstinh.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dstinh[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtNoiCap.text = dstinh[row]
    }
    
}
