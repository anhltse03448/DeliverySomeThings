//
//  RegisInforFamilyViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/22/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

class Children : NSObject {
    var name : String
    var ngaySinh : String
    var gioiTinh : String
    
    init(name : String , ngaySinh : String, gioiTinh : String) {
        self.name = name
        self.ngaySinh = ngaySinh
        self.gioiTinh = gioiTinh
    }
}

class RegisInforFamilyViewController: UIViewController {
    @IBOutlet weak var imgBack : UIImageView!
    @IBOutlet weak var tbl : UITableView!
    @IBOutlet weak var txtTenNguoiLH : UITextField!
    @IBOutlet weak var txtSDT : UITextField!
    @IBOutlet weak var btnDaKH : UIButton!
    @IBOutlet weak var btnChuaKH : UIButton!
    @IBOutlet weak var btnKhac : UIButton!
    @IBOutlet weak var txtHoTenVC : UITextField!
    @IBOutlet weak var txtNgaySinh : UITextField!
    
    @IBOutlet weak var txtHoTenCon : UITextField!
    @IBOutlet weak var txtNgaySinhCon : UITextField!
    @IBOutlet weak var btnNam : UIButton!
    @IBOutlet weak var btnNu : UIButton!
    @IBOutlet weak var btnAdd : UIButton!
    
    var identifier = "RegisInfoFamilyTableViewCell"
    var count = 0
    var param : [String : String] = [:]
    var listChildren : [Children] = []
    var fileName : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listChildren.removeAll()
        self.count = 0
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisInforFamilyViewController.dismisBack(_:))))
        btnDaKH.setImage(UIImage.init(named: "checked"), for: UIControlState.selected)
        btnChuaKH.setImage(UIImage.init(named: "checked"), for: UIControlState.selected)
        btnKhac.setImage(UIImage.init(named: "checked"), for: UIControlState.selected)
        btnNam.setImage(UIImage.init(named: "checked"), for: UIControlState.selected)
        btnNu.setImage(UIImage.init(named: "checked"), for: UIControlState.selected)
        
        btnDaKH.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        btnChuaKH.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        btnKhac.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        btnNam.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        btnNu.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        
        tbl.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        tbl.separatorStyle = .none
        
        btnDaKH.isSelected = false
        btnChuaKH.isSelected = true
        btnKhac.isSelected = false
        
        txtHoTenVC.isHidden = true
        txtNgaySinh.isHidden = true
        tbl.isHidden = true
        
        txtHoTenCon.isHidden = true
        txtNgaySinhCon.isHidden = true
        btnNam.isHidden = true
        btnNu.isHidden = true
        btnAdd.isHidden = true
        btnNam.isSelected = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismisBack(_ gesture : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSttTouchUp(_ sender : UIButton) {
        switch sender {
        case btnDaKH:
            btnDaKH.isSelected = true
            btnChuaKH.isSelected = false
            btnKhac.isSelected = false
            
            txtHoTenVC.isHidden = false
            txtNgaySinh.isHidden = false
            tbl.isHidden = false
            
            txtHoTenCon.isHidden = false
            txtNgaySinhCon.isHidden = false
            btnNam.isHidden = false
            btnNu.isHidden = false
            btnAdd.isHidden = false
            
        case btnChuaKH:
            btnDaKH.isSelected = false
            btnChuaKH.isSelected = true
            btnKhac.isSelected = false
            
            txtHoTenVC.isHidden = true
            txtNgaySinh.isHidden = true
            tbl.isHidden = true
            
            txtHoTenCon.isHidden = true
            txtNgaySinhCon.isHidden = true
            btnNam.isHidden = true
            btnNu.isHidden = true
            btnAdd.isHidden = true
        default:
            btnDaKH.isSelected = false
            btnChuaKH.isSelected = false
            btnKhac.isSelected = true
            
            txtHoTenVC.isHidden = false
            txtNgaySinh.isHidden = false
            tbl.isHidden = false
            
            txtHoTenCon.isHidden = false
            txtNgaySinhCon.isHidden = false
            btnNam.isHidden = false
            btnNu.isHidden = false
            btnAdd.isHidden = false
        }
    }
    
    @IBAction func btnAddTouchUp(_ sender : UIButton) {
        
        let name = txtHoTenCon.text ?? ""
        let ngaySinh = txtNgaySinhCon.text ?? ""
        if name == "" {
            self.view.makeToast("Nhập tên con", duration: 2.0, position: .center)
            return
        }
        if ngaySinh == "" {
            self.view.makeToast("Nhập ngày sinh con", duration: 2.0, position: .center)
            return
        }
        txtHoTenCon.text = ""
        txtNgaySinhCon.text = ""
        var gioitinh = ""
        if btnNam.isSelected {
           gioitinh = "nam"
        } else if btnNu.isSelected {
           gioitinh = "nu"
        }
        btnNam.isSelected = true
        
        listChildren.append(Children(name: name, ngaySinh: ngaySinh, gioiTinh: gioitinh))
        tbl.reloadData()
    }
    
    @IBAction func btnNext(_ sender : UIButton){
        let nguoi_lien_he = txtTenNguoiLH.text ?? ""
        let phone_lien_he = txtSDT.text ?? ""
        
        if nguoi_lien_he == "" {
            self.view.makeToast("Nhập tên người liên hệ", duration: 2.0, position: .center)
            return
        }
        
        if phone_lien_he == "" {
            self.view.makeToast("Nhập sdt tên người liên hệ", duration: 2.0, position: .center)
            return
        }
        
        let vc = RegisInfoAccountViewController(nibName: "RegisInfoAccountViewController", bundle: nil)
        var ttKetHon = ""
        if btnKhac.isSelected {
           ttKetHon = "KHAC"
        } else if btnDaKH.isSelected {
           ttKetHon = "DA_KET_HON"
        } else if btnChuaKH.isSelected {
           ttKetHon = "CHUA_KET_HON"
        }
        var tenVC = ""
        var ngaysinhVC = ""
        if btnDaKH.isSelected == true {
            tenVC = txtHoTenVC.text ?? ""
            ngaysinhVC = txtNgaySinh.text ?? ""
            if tenVC == "" {
                self.view.makeToast("Nhập tên vợ chồng", duration: 2.0, position: .center)
                return
            } else if ngaysinhVC == "" {
                self.view.makeToast("Nhập ngày sinh vợ chồng", duration: 2.0, position: .center)
                return
            }
        }
        
        
        vc.param1 = self.param
        vc.nguoi_lien_he = nguoi_lien_he
        vc.phone_lien_he = phone_lien_he
        vc.listChildren = self.listChildren
        vc.ttHonNhan = ttKetHon
        vc.fileName = self.fileName
        vc.tenVC = tenVC
        vc.ngaySinhVC = ngaysinhVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didChange(_ sender : UITextField) {
        let txt = sender.text ?? ""
        if txt == "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            sender.text = dateFormatter.string(from: Date())            
        }
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(RegisInforFamilyViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func didChangeCon(_ sender : UITextField) {
        let txt = sender.text ?? ""
        if txt == "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            sender.text = dateFormatter.string(from: Date())
        }
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(RegisInforFamilyViewController.datePickerValueChangedCon(sender:)), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtNgaySinh.text = dateFormatter.string(from: sender.date)
    }
    
    func datePickerValueChangedCon(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtNgaySinhCon.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func btnNamNuTouchUp(_ sender : UIButton){
        if sender == btnNam {
            btnNam.isSelected = true
            btnNu.isSelected = false
        } else {
            btnNu.isSelected = true
            btnNam.isSelected = false
        }
    }
}
extension RegisInforFamilyViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listChildren.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! RegisInfoFamilyTableViewCell
        cell.delegate = self
        cell.setData(obj: listChildren[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
extension RegisInforFamilyViewController : DeleteRegis {
    func delete(cell: RegisInfoFamilyTableViewCell) {
        let index = tbl.indexPath(for: cell)
        self.listChildren.remove(at: (index?.row)!)
        tbl.deleteRows(at: [index!], with: UITableViewRowAnimation.none)
    }
}

