//
//  ReceiveDetailTableViewCell.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/11/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

class ReceiveDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl1 : UILabel!
    @IBOutlet weak var btnChecked : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
