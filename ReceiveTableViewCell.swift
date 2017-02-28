//
//  ReceiveTableViewCell.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/19/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
protocol ReceiveCellDelegate {
    func mapTouchUp(cell : ReceiveTableViewCell)
    func callTouchUp(cell : ReceiveTableViewCell)
}

class ReceiveTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl1 : UILabel!
    @IBOutlet weak var lbl2 : UILabel!
    let cellIdentifier = "ReceiveDetailTableViewCell"
    var indexCell : Int?
    var delegate : ReceiveCellDelegate?
    var dia_chi_nhan : String?
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(rcp : ReceivePerson , count : Int) {
        lbl1.text = rcp.ten_nguoi_gui + "( \(count) )"
        lbl2.text = rcp.dia_chi_nguoi_gui
        dia_chi_nhan = rcp.dia_chi_nhan
    }
    
    @IBAction func mapTouchUp(_ sender : UIButton) {
        if delegate != nil {
            delegate?.mapTouchUp(cell: self)
        }
    }
    
    @IBAction func callTouchUp(_ sender : UIButton) {
        if delegate != nil {
            delegate?.callTouchUp(cell: self)
        }
    }
}
