//
//  RegisInfoFamilyTableViewCell.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/11/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

protocol DeleteRegis {
    func delete(cell : RegisInfoFamilyTableViewCell)
}

class RegisInfoFamilyTableViewCell: UITableViewCell {
    @IBOutlet weak var lblGioiTinh: UILabel!
    @IBOutlet weak var lblNgaySinh : UILabel!
    @IBOutlet weak var lblHoTenCon : UILabel!
    var delegate : DeleteRegis?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(obj : Children) {
        self.lblGioiTinh.text = obj.gioiTinh
        self.lblNgaySinh.text = obj.ngaySinh
        self.lblHoTenCon.text = obj.name
    }
    @IBAction func btnAddTouchUp(_ sender : UIButton) {
        if delegate != nil {
            delegate?.delete(cell: self)
        }
    }
}
