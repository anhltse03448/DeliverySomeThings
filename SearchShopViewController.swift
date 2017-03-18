//
//  SearchShopViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 3/4/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import STPopup
import Alamofire
import SwiftyJSON

class SearchShopViewController: BaseViewController {
    @IBOutlet weak var txtSearch : UITextField!
    @IBOutlet weak var tbl : UITableView!
    var listNV = [NguoiGui]()
    var listShow = [NguoiGui]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupController?.navigationBarHidden = true
        self.contentSizeInPopup = CGSize(width: 300, height: 300)
        self.requestNguoiGui()
        tbl.register(UINib.init(nibName: "ShopNameTableViewCell", bundle: nil), forCellReuseIdentifier: "ShopNameTableViewCell")
        tbl.tableFooterView = UIView.init(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func requestNguoiGui() {
        self.listNV.removeAll()
        let session = self.getSession()
        let param : [String : String] = ["session" : session]
        Alamofire.request("http://www.giaohangongvang.com/api/dieuvan/danh-sach-nguoi-gui", method: .post, parameters: param).responseJSON { (response) in
            if response.data != nil {
                let data = JSON.init(data: response.data!)
                NSLog("\(data)")
                let dta = data["detail"].array
                if dta != nil {
                    for item in dta! {
                        self.listNV.append(NguoiGui(json: item))
                    }
                } else {
                    let warning = data["warning"].stringValue
                    ReceiveTakePicViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
                    self.popupController?.dismiss(completion: { 
                        let obj = ["name" : "" ]
                        NotificationCenter.default.post(name: NSNotification.Name.init("ChooseShop"), object: obj)
                    })
                }
            }
            self.listShow = self.listNV
            self.tbl.reloadData()
        }
    }
    
    @IBAction func CHDidBegin(_ sender: Any) {
        self.listShow =  filter(a: txtSearch.text ?? "")
        tbl.reloadData()
    }
    
    func filter(a : String) -> [NguoiGui]{
        var res = [NguoiGui]()
        for item in self.listNV {
            let name = item.ten_nguoi_gui.lowercased()
            let a1 = a.lowercased()
            if name.contains(a1) {
                res.append(item)
            }
        }
        return res
    }
}
extension SearchShopViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listShow.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopNameTableViewCell", for: indexPath) as! ShopNameTableViewCell
        cell.lblTitle.text = self.listShow[indexPath.row].ten_nguoi_gui
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.popupController?.dismiss(completion: {
            let obj = ["name" : self.listShow[indexPath.row].ten_nguoi_gui ]
            NotificationCenter.default.post(name: NSNotification.Name.init("ChooseShop"), object: obj)
        })
    }
}
