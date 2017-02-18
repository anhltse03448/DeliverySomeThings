//
//  DonHoanTableViewCell.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/15/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

class DonHoanTableViewCell: UITableViewCell {
    @IBOutlet weak var lblId : UILabel!
    @IBOutlet weak var lblNguoi_gui : UILabel!
    @IBOutlet weak var lblNguoi_nhan : UILabel!
    @IBOutlet weak var lblsdt_nguoi_nhan : UILabel!
    @IBOutlet weak var lbldcNhan : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(dov : DeliveryObject) {
        self.lblId.text = "id đơn hàng: \(dov.id_don_hang)"
        self.lblNguoi_gui.text = "Người gửi: \(dov.ten_nguoi_gui)"
        self.lblNguoi_nhan.text = "Người nhận: \(dov.ten_nguoi_nhan)"
        self.lblsdt_nguoi_nhan.text = "Sdt người nhận: \(dov.sdt_nguoi_nhan)"
        self.lbldcNhan.text = "Dc người nhận: \(dov.dia_chi_nguoi_nhan)"
    }
    
}
