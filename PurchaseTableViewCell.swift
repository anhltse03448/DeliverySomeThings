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
    
    func setData() {
        
    }
    
}
