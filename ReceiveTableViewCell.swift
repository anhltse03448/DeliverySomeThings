//
//  ReceiveTableViewCell.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/19/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

class ReceiveTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl1 : UILabel!
    @IBOutlet weak var lbl2 : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(rcp : ReceivePerson) {
        lbl1.text = rcp.ten_nguoi_gui
        lbl2.text = rcp.dia_chi_nhan
    }
}
