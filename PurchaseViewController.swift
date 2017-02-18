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
    static let sharedInstance = PurchaseViewController()
    var sotien : Int = 0
    var listDelivery = [DeliveryObject]()
    let identifier = "DonHoanTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.rowHeight = UITableViewAutomaticDimension
        tbl.estimatedRowHeight = 100
        tbl.separatorStyle = .none
        tbl.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadSoTienCanThanhToan()
        self.loadDSdon()
    }
    
    func loadSoTienCanThanhToan() {
        let param : [String : String] = ["session" : self.getSession()]
        Alamofire.request("http://www.giaohangongvang.com/api/thanhtoan/thanhtoan", method: .post, parameters: param).responseJSON { (response) in
            let data = JSON.init(data: response.data!)
            NSLog("\(data)")
            let status = data["status"].stringValue
            if status != "fail" {
                let tt = data["detail"]["can_thanh_toan"].stringValue
                self.sotien = Int(tt) ?? 0
            } else {
                let warning = data["warning"].stringValue
                PurchaseViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
            }
        }
    }
    
    func loadDSdon() {
        let param : [String : String] = ["session" : self.getSession()]
        Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/list-donhang-thanhtoan", method: .post, parameters: param).responseJSON { (response) in
            let data = JSON.init(data: response.data!)
            NSLog("\(data)")
            let status = data["status"].stringValue
            var tmp = [DeliveryObject]()
            if status != "fail" {
                let details = data["detail"].arrayValue
                for item in details {
                    let dov = DeliveryObject(json: item)
                    tmp.append(dov)
                    self.tbl.reloadData()
                }
                self.listDelivery = tmp
                
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
        let cell = tbl.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DonHoanTableViewCell
        cell.setData(dov: self.listDelivery[indexPath.row])
        
        return cell
    }
}
