//
//  RegisInforFamilyViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/22/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

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
    
    var identifier = "RegisInfoFamilyTableViewCell"
    var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisInforFamilyViewController.dismisBack(_:))))
        btnDaKH.setImage(UIImage.init(named: "checked"), for: UIControlState.selected)
        btnChuaKH.setImage(UIImage.init(named: "checked"), for: UIControlState.selected)
        btnKhac.setImage(UIImage.init(named: "checked"), for: UIControlState.selected)
        
        btnDaKH.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        btnChuaKH.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        btnKhac.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        
        tbl.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        tbl.separatorStyle = .none
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismisBack(_ gesture : UITapGestureRecognizer) {
        self.navigationController?.dismiss(animated: true, completion: { 
            
        })
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
            
            
        case btnChuaKH:
            btnDaKH.isSelected = false
            btnChuaKH.isSelected = true
            btnKhac.isSelected = false
            
            txtHoTenVC.isHidden = true
            txtNgaySinh.isHidden = true
            tbl.isHidden = true
        default:
            btnDaKH.isSelected = false
            btnChuaKH.isSelected = false
            btnKhac.isSelected = true
            
            txtHoTenVC.isHidden = false
            txtNgaySinh.isHidden = false
            tbl.isHidden = false
        }
    }
}
extension RegisInforFamilyViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tbl.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! RegisInfoFamilyTableViewCell
            return cell
        } else {
            let cell = tbl.dequeueReusableCell(withIdentifier: "RegisNormalTableViewCell", for: indexPath) as! RegisNormalTableViewCell
            return cell
        }
    }
}
