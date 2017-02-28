//
//  RegisInfoFamilyTableViewCell.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/11/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

class RegisInfoFamilyTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_ho_ten : UILabel!
    @IBOutlet weak var lblNgaySinh : UILabel!
    @IBOutlet weak var lblHoTenCon : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
