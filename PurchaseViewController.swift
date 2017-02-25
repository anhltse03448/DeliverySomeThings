//
//  PurchaseViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/21/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PurchaseViewController: BaseViewController {
    @IBOutlet weak var tbl : UITableView!
    
    @IBOutlet weak var lblCanThanhToan : UILabel!
    @IBOutlet weak var lblTTTrongNgay : UILabel!
    @IBOutlet weak var lblNo : UILabel!
    
    static let sharedInstance = PurchaseViewController()
    var sotien : Double = 0
    var listDelivery = [Purchase]()
    let identifier = "PurchaseTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.rowHeight = UITableViewAutomaticDimension
        tbl.estimatedRowHeight = 100
        tbl.tableFooterView = UIView.init(frame: CGRect.zero)
        
        tbl.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadSoTienCanThanhToan()
        //self.loadDSdon()
    }
    
    func loadSoTienCanThanhToan() {
        let param : [String : String] = ["session" : self.getSession()]
        Alamofire.request("http://www.giaohangongvang.com/api/thanhtoan/thanhtoan", method: .post, parameters: param).responseJSON { (response) in
            
            let data = JSON.init(data: response.data!)
            NSLog("\(data)")
            let status = data["status"].stringValue
            if status != "fail" {
                NSLog("\(data["detail"])")
                let a = data["detail"]
                NSLog("\(a.stringValue)")
                let k = JSON.init(parseJSON: a.stringValue)
                let h = k["can_thanh_toan"].doubleValue
                self.sotien = h
                
                self.lblCanThanhToan.text = Int(self.sotien).stringFormattedWithSeparator
                self.loadDSdon()
            } else {
                let warning = data["warning"].stringValue
                PurchaseViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
            }
        }
    }
    
    func loadDSdon() {
        var sum : Double = 0
        let param : [String : String] = ["session" : self.getSession()]
        Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/list-donhang-thanhtoan", method: .post, parameters: param).responseJSON { (response) in
            let data = JSON.init(data: response.data!)
            NSLog("\(data)")
            let status = data["status"].stringValue
            var tmp = [Purchase]()
            if status != "fail" {
                let details = data["detail"].arrayValue
                for item in details {
                    let dov = Purchase(json: item)
                    let mo = Double(dov.nguoi_nhan_thanh_toan.replacingOccurrences(of: ",", with: "")) ?? 0
                    sum = sum + mo
                    tmp.append(dov)
                }
                
                self.lblTTTrongNgay.text = Int(sum).stringFormattedWithSeparator
                self.lblNo.text = Int(self.sotien - sum).stringFormattedWithSeparator
                
                self.listDelivery = tmp
                self.tbl.reloadData()
                
            } else {
                let warning = data["warning"].stringValue
                PurchaseViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
                self.listDelivery = tmp
                self.tbl.reloadData()
            }
        }
    }
}

extension PurchaseViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listDelivery.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PurchaseTableViewCell
        cell.setData(purchase: self.listDelivery[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tbl.deselectRow(at: indexPath, animated: true)
    }
}
