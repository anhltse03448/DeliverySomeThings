//
//  PhoneSearchTableViewCell.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/7/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol PhoneSearchDelegate {
    func nhan(cell : PhoneSearchTableViewCell)
}

class PhoneSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var lblNguoiGui : UILabel!
    @IBOutlet weak var lblNguoiNhan : UILabel!
    @IBOutlet weak var lblDiaChiNhan : UILabel!
    @IBOutlet weak var lblThuHo : UILabel!
    @IBOutlet weak var btnNhan : UIButton!
    var delegate : PhoneSearchDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ dov : DeliveryObject) {
        self.lblNguoiGui.text = "Người gửi: " + dov.ten_nguoi_gui
        self.lblNguoiNhan.text = "Người nhận: " + dov.sdt_nguoi_nhan
        self.lblDiaChiNhan.text = "Địa chỉ nhận: " + dov.sdt_nguoi_nhan
        self.lblThuHo.text = "Thu hộ"
    }
    
    @IBAction func btnNhanTouchUp(_ sender : UIButton) {
        if self.delegate != nil {
            delegate?.nhan(cell: self)
        }        
    }
}
