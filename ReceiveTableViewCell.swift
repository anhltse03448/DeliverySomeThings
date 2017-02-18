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
    @IBOutlet weak var viewTop : UIView!
    @IBOutlet weak var lbl1 : UILabel!
    @IBOutlet weak var lbl2 : UILabel!
    @IBOutlet weak var tbl : UITableView!
    let cellIdentifier = "ReceiveDetailTableViewCell"
    var indexCell : Int?
    var delegate : ReceiveCellDelegate?
    var dia_chi_nhan : String?
    override func awakeFromNib() {
        
        super.awakeFromNib()
        tbl.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tbl.delegate = self
        tbl.dataSource = self
        tbl.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(ReceiveTableViewCell.reloadData(notification:)), name: NSNotification.Name.init("UpdateReceive"), object: nil)
    }
    
    func reloadData(notification : Notification) {
        
            self.tbl.reloadData()
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
        let testURL = URL(string: "comgooglemaps-x-callback://")!
        if UIApplication.shared.canOpenURL(testURL) {
            let directionsRequest = "comgooglemaps-x-callback://" +
                "?daddr=John+F.+Kennedy+International+Airport,+Van+Wyck+Expressway,+Jamaica,+New+York" +
            "&x-success=sourceapp://?resume=true&x-source=AirApp"
            
            let directionsURL = URL(string: directionsRequest)!
            UIApplication.shared.openURL(directionsURL)
        } else {
            NSLog("Can't use comgooglemaps-x-callback:// on this device.")
        }
    }
    
    @IBAction func callTouchUp(_ sender : UIButton) {
        if delegate != nil {
            delegate?.callTouchUp(cell: self)
        }
    }
}
extension ReceiveTableViewCell : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if indexCell != nil {
            if ReceiveViewController.sharedInstance.listShow.count <= indexCell! {
                return 0
            }
            let listShow = ReceiveViewController.sharedInstance.listShow[self.indexCell!]
            NSLog("\(listShow.listObj?.count)")
            if listShow != nil {
                if listShow.listObj != nil {
                    return (listShow.listObj?.count)!
                } else {
                    return 0
                }
            } else {
                return 0
            }
        } else {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listShow = ReceiveViewController.sharedInstance.listShow[self.indexCell!]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ReceiveDetailTableViewCell
        cell.lbl1.text = listShow.listObj?[indexPath.row].dia_chi_nhan
        if listShow.listChecked?[indexPath.row] == true {
            cell.btnChecked.imageView?.image = UIImage(named: "checked")
        } else {
            cell.btnChecked.imageView?.image = UIImage(named: "unchecked")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ReceiveViewController.sharedInstance.listShow[self.indexCell!].listChecked?[indexPath.row] = !(ReceiveViewController.sharedInstance.listShow[self.indexCell!].listChecked?[indexPath.row])!
        tbl.reloadData()
    }
}
