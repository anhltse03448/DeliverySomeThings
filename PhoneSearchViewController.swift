//
//  PhoneSearchViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/28/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import STPopup

class PhoneSearchViewController: BaseViewController {
    static let sharedInstance = PhoneSearchViewController()
    @IBOutlet weak var txtSearch : UITextField!
    @IBOutlet weak var imgSearch : UIButton!
    @IBOutlet weak var tbl : UITableView!
    let identifier = "PhoneSearchTableViewCell"
    
    var listDvo = [DeliveryObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismisKeyboard(_:))))
        tbl.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        tbl.tableFooterView = UIView.init(frame: CGRect.zero)    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtSearch.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func searchPhone(_ sender : UIButton) {
        txtSearch.resignFirstResponder()
        let phone = txtSearch.text ?? ""
        if phone == "" {
            self.view.makeToast("Chưa nhập phone", duration: 2.0, position: .center)
            return
        }
        let session = self.getSession()
        let param : [String : String] = ["session" : session ,
                                         "sdt_nguoi_nhan" : phone.toBase64()]
        var tmp = [DeliveryObject]()
        Alamofire.request("http://www.giaohangongvang.com/api/donhang/search-don-ton", method: .post, parameters: param).responseJSON { (response) in
            if response.data != nil {
                let json = JSON.init(data: response.data!)
                let status = json["status"].stringValue
                if status == "fail" {
                    let warning = json["warning"].stringValue
                    NhanDonGiaoViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
                } else {
                    let content = json["detail"]
                    if content.arrayValue.count == 0 {
                        let dongiaoMoi = DonGIaoMoiViewController(nibName: "DonGIaoMoiViewController", bundle: nil)
                        let stpopup = STPopupController(rootViewController: dongiaoMoi)
                        dongiaoMoi.sdt = self.txtSearch.text
                        stpopup.present(in: self)
                        return
                    }
                    for item in content.arrayValue {
                        let dvo = DeliveryObject.init(json: item)
                        tmp.append(dvo)
                    }
                    self.listDvo = tmp
                    DispatchQueue.main.async {
                        self.tbl.reloadData()
                    }

                }
            } else {
                self.listDvo = tmp
                DispatchQueue.main.async {
                    self.tbl.reloadData()
                }
            }
        }
        
        
    }
    func dismisKeyboard(_ gesture : UITapGestureRecognizer) {
        txtSearch.resignFirstResponder()
    }
}
extension PhoneSearchViewController : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listDvo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PhoneSearchTableViewCell
        cell.setData(listDvo[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
extension PhoneSearchViewController : PhoneSearchDelegate {
    func nhan(cell: PhoneSearchTableViewCell) {
        let indexPath = tbl.indexPath(for: cell)
        let dov = listDvo[(indexPath?.row)!]
        
        let id = dov.id_don_hang
        self.listDvo.remove(at: (indexPath?.row)!)
        tbl.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
        //NSLog("\(dov.id_don_hang)")
        let param : [String : String] = ["session": self.getSession() , "list" : (id.toBase64()) ]
        Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/nhan-donhang-ton", method: .post, parameters: param).responseJSON { (response) in
            if response.data != nil {
                let json = JSON.init(data: response.data!)
                let warning = json["warning"].stringValue
                NhanDonGiaoViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
                self.listDvo.removeAll()
                self.txtSearch.text = ""
            } else {
                
            }
        }
    }
}
