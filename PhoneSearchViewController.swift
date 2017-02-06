//
//  PhoneSearchViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/28/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire

class PhoneSearchViewController: UIViewController {
    @IBOutlet weak var txtSearch : UITextField!
    @IBOutlet weak var imgSearch : UIButton!
    @IBOutlet weak var tbl : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchPhone(_ sender : UIButton) {
        let phone = txtSearch.text ?? ""
        let session = (UserDefaults.standard.value(forKey: UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.session)) as! String ).toBase64()
        let param : [String : String] = ["session" : session ,
                                         "sdt_nguoi_nhan" : phone.toBase64()]
        Alamofire.request("http://www.giaohangongvang.com/api/donhang/search-don-ton", method: .post, parameters: param).responseJSON { (response) in
            
            
        }
    }
}
