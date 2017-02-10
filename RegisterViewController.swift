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
    
    let imagePicker = UIImagePickerController()
    var dstinh = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dstinh = self.readDsTinh()
        imagePicker.delegate = self
        img_back.isUserInteractionEnabled = true
        img_back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.back_touchUp(_:))))
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismisKeyboard(_:))))
        imgPick.isUserInteractionEnabled = true
        imgPick.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.pickImage(_:))))
        setPickerView()
    }
    
    func pickImage(_ gesture : UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "From Camera", style: .default , handler:{ (UIAlertAction)in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "From Gallery", style: .default , handler:{ (UIAlertAction)in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func txtNgayCapDidChange(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(RegisterViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
    }
    
    func dismisKeyboard(_ gesture : UITapGestureRecognizer) {
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
    
    @IBAction func dp(sender: UITextField) {
        
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(RegisterViewController.handleDatePicker(sender:)), for: .valueChanged)
    }
    
    func setPickerView() {
        
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        txtNoiCap.inputView = pickerView
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        txtNgaySinh.text = dateFormatter.string(from: sender.date)
    }
}
extension RegisterViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imgPick.image = pickedImage
            
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
