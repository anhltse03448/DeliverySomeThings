//
//  DonHenGiaoViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/24/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DonHenGiaoViewController: BaseViewController {
    static let sharedInstance = DonHenGiaoViewController()
    @IBOutlet weak var tbl : UITableView!
    var listDelivery = [DeliveryObject]()
    let identifier = "DonHoanTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()

        tbl.rowHeight = UITableViewAutomaticDimension
        tbl.estimatedRowHeight = 100
        tbl.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        tbl.tableFooterView = UIView.init(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.loadDonHenGiao()
    }
    
    func loadDonHenGiao() {
        self.showLoadingHUD()
        let param : [String : String] = ["session" : self.getSession()]
        var tmp = [DeliveryObject]()
        Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/list-donhang-hen", method: .post, parameters: param).responseJSON { (response) in
            self.hideLoadingHUD()
            let data = JSON.init(data: response.data!)
            NSLog("\(data)")
            let status = data["status"].stringValue
            if status != "fail" {
                let details = data["detail"].arrayValue
                for item in details {
                    let dov = DeliveryObject(json: item)
                    tmp.append(dov)
                }
                self.listDelivery = tmp
                self.tbl.reloadData()
            } else {
                let warning = data["warning"].stringValue
                HangVeKhoViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
            }
            
        }
    }
}
extension DonHenGiaoViewController : UITableViewDataSource,UITableViewDelegate {
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
