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

class PhoneSearchViewController: UIViewController {
    @IBOutlet weak var txtSearch : UITextField!
    @IBOutlet weak var imgSearch : UIButton!
    @IBOutlet weak var tbl : UITableView!
    let identifier = "PhoneSearchTableViewCell"
    
    var listDvo = [DeliveryObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismisKeyboard(_:))))
        tbl.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        tbl.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchPhone(_ sender : UIButton) {
        txtSearch.resignFirstResponder()
        let phone = txtSearch.text ?? ""
        let session = (UserDefaults.standard.value(forKey: UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.session)) as! String ).toBase64()
        let param : [String : String] = ["session" : session ,
                                         "sdt_nguoi_nhan" : phone.toBase64()]
        var tmp = [DeliveryObject]()
        Alamofire.request("http://www.giaohangongvang.com/api/donhang/search-don-ton", method: .post, parameters: param).responseJSON { (response) in
            let json = JSON.init(data: response.data!)
            let content = json["detail"]
            for item in content.arrayValue {
                let dvo = DeliveryObject.init(json: item)
                tmp.append(dvo)
            }
            self.listDvo = tmp
        }
        
        DispatchQueue.main.async {
            self.tbl.reloadData()
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
        
        let session = UserDefaults.standard.value(forKey: UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.session)) as! String
        let id = dov.id_don_hang
        NSLog("\(dov.id_don_hang)")
        let param : [String : String] = ["session": session.toBase64() , "list" : (id.toBase64()) ]
        Alamofire.request("", method: .post, parameters: param).responseJSON { (response) in
            let json = JSON.init(data: response.data!)
            NSLog("\(json["warning"])")
        }
    }
}
