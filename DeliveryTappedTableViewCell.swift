//
//  DeliveryTappedTableViewCell.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/25/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

protocol DeliveryDelegate {
    func hoanthanh(cell : DeliveryTappedTableViewCell)
    func hoandon(cell : DeliveryTappedTableViewCell)
    func ghichu(cell : DeliveryTappedTableViewCell)
    func call(cell : DeliveryTappedTableViewCell)
}

class DeliveryTappedTableViewCell: UITableViewCell {
    @IBOutlet weak var icon_map : UIImageView!
    @IBOutlet weak var lblDcNhan : UILabel!
    @IBOutlet weak var lblNgayHenGiao : UILabel!
    @IBOutlet weak var gioHenGiao : UILabel!
    @IBOutlet weak var viewTop : UIView!
    @IBOutlet weak var lblId : UILabel!
    @IBOutlet weak var lblPhone : UILabel!
    @IBOutlet weak var lblNote : UILabel!
    @IBOutlet weak var btnHoanThanh : UIButton!
    @IBOutlet weak var btnHoanDon : UIButton!
    @IBOutlet weak var btnGhiChu : UIButton!
    @IBOutlet weak var btnCall : UIButton!
    var delegate : DeliveryDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblNote.lineBreakMode = NSLineBreakMode.byWordWrapping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(deo : DeliveryObject) {
        self.lblDcNhan.text = deo.dia_chi_nguoi_nhan
        self.lblNgayHenGiao.text = deo.ngay_hen_giao
        self.gioHenGiao.text = deo.ngay_hen_giao
        self.viewTop.backgroundColor = UIColor.init(rgba: "#EBB003")
        self.lblId.text = deo.id_don_hang
        self.lblPhone.text = deo.sdt_nguoi_nhan
        let ghichu = deo.ghi_chu.replacingOccurrences(of: "\n", with: " \n ")
        self.lblNote.text = ghichu
        
    }
    @IBAction func btnTap(_ sender : UIButton) {
        if delegate != nil {
            switch sender {
            case btnHoanThanh:
                delegate?.hoanthanh(cell: self)
            case btnHoanDon:
                delegate?.hoandon(cell: self)
            case btnGhiChu:
                delegate?.ghichu(cell: self)
            default:
                delegate?.call(cell: self)
            }
        }
    }
}
