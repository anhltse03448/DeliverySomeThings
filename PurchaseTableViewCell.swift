//
//  PurchaseTableViewCell.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/18/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

class PurchaseTableViewCell: UITableViewCell {
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblNguoiGui : UILabel!
    @IBOutlet weak var lblDCNguoiNhan: UILabel!
    @IBOutlet weak var sdt_nguoi_nhan : UILabel!
    @IBOutlet weak var lblCod : UILabel!
    @IBOutlet weak var lblThucThu : UILabel!
    @IBOutlet weak var lblGhiChu : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(purchase : Purchase) {
        self.lblID.text = "ID đơn hàng: " + purchase.id_don_hang.replacingOccurrences(of: "\\n", with: "\n")
        self.lblNguoiGui.text = "Người gửi: " + purchase.ten_nguoi_gui.replacingOccurrences(of: "\\n", with: "\n")
        self.lblDCNguoiNhan.text = "Địa chỉ người nhận: " + purchase.dia_chi_nguoi_nhan.replacingOccurrences(of: "\\n", with: "\n")
        self.sdt_nguoi_nhan.text = "SDT: " + purchase.sdt_nguoi_nhan.replacingOccurrences(of: "\\n", with: "\n")
        self.lblCod.text = "COD: " + purchase.cod.replacingOccurrences(of: "\\n", with: "\n").stringFormattedWithSeprator
        self.lblThucThu.text = "Thực thu: " + purchase.nguoi_nhan_thanh_toan.replacingOccurrences(of: "\\n", with: "\n").stringFormattedWithSeprator
        self.lblGhiChu.text = "Ghi Chú: " + purchase.ghi_chu.replacingOccurrences(of: "\\n", with: "\n")
    }
    
}
