//
//  DeliveryTableViewCell.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/25/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

class DeliveryTableViewCell: UITableViewCell {
    @IBOutlet weak var icon_map : UIImageView!
    @IBOutlet weak var lblDcNhan : UILabel!
    @IBOutlet weak var lblNgayHenGiao : UILabel!
    @IBOutlet weak var gioHenGiao : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(deo : DeliveryObject) {
        self.lblDcNhan.text = deo.dia_chi_nguoi_nhan
        self.lblNgayHenGiao.text = deo.ngay_hen_giao
        self.gioHenGiao.text = deo.ngay_hen_giao
    }
    
}
