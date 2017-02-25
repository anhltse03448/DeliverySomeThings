//
//  DeliveryCollectionViewCell.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/13/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
protocol DeliveryDelegate {
    func hoanthanh(cell : DeliveryCollectionViewCell)
    func hoandon(cell : DeliveryCollectionViewCell)
    func ghichu(cell : DeliveryCollectionViewCell)
    func call(cell : DeliveryCollectionViewCell)
    func touchMap(cell : DeliveryCollectionViewCell)
    func expandse(cell : DeliveryCollectionViewCell)
}

class DeliveryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewTop : UIView!
    @IBOutlet weak var lblDC : UILabel!
    @IBOutlet weak var imgMap : UIImageView!
    
    @IBOutlet weak var lblbarcode : UILabel!
    @IBOutlet weak var lbltenNhan : UILabel!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblPhone : UILabel!
    @IBOutlet weak var lblCash : UILabel!
    
    @IBOutlet weak var lblNote : UILabel!
    
    @IBOutlet weak var height1: NSLayoutConstraint!
    @IBOutlet weak var height2: NSLayoutConstraint!
    @IBOutlet weak var height3: NSLayoutConstraint!
    @IBOutlet weak var height4: NSLayoutConstraint!
    @IBOutlet weak var height5: NSLayoutConstraint!
    @IBOutlet weak var height6: NSLayoutConstraint!
    @IBOutlet weak var height7: NSLayoutConstraint!
    
    @IBOutlet weak var imgChuyen : UIImageView!
    
    var delegate : DeliveryDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        imgMap.isUserInteractionEnabled = true
        imgMap.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DeliveryCollectionViewCell.mapTouch(_:))))
        viewTop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DeliveryCollectionViewCell.expandse(_:))))
    }
    func setData(item : DeliveryObject) {
        self.lblDC.text = item.dia_chi_nguoi_nhan
        if self.lblDC.text == "" {
            self.lblDC.text = "Chưa có địa chỉ nhận"
        }
        self.lblbarcode.text = item.id_don_hang
        self.lbltenNhan.text = item.ten_nguoi_gui
        self.lblName.text = item.ten_nguoi_nhan
        self.lblPhone.text = item.sdt_nguoi_nhan
        self.lblCash.text = Int(item.cod)?.stringFormattedWithSeparator
        self.lblNote.text = item.ghi_chu.replacingOccurrences(of: "\\n", with: "\n")
        
    }
    
    func expandse(_ gesture : UITapGestureRecognizer){
        if delegate != nil {
            delegate?.expandse(cell: self)
        }
    }
    
    func mapTouch(_ gesture : UITapGestureRecognizer) {
        if delegate != nil {
            delegate?.touchMap(cell: self)
        }
    }
    
    @IBAction func hoanthanhTouchUp(_ sender : UIButton){
        if delegate != nil {
            delegate?.hoanthanh(cell: self)
        }
    }
    
    @IBAction func hoandonTouchUp(_ sender : UIButton){
        if delegate != nil {
            delegate?.hoandon(cell: self)
        }
    }
    @IBAction func callTouchUp(_ sender : UIButton){
        if delegate != nil {
            delegate?.call(cell: self)
        }
    }
    @IBAction func ghiChuTouchUp(_ sender : UIButton){
        if delegate != nil {
            delegate?.ghichu(cell: self)
        }
    }
}
