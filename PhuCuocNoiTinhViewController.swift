//
//  PhuCuocNoiTinhViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/24/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PhuCuocNoiTinhViewController: BaseViewController {
    var dov : DeliveryObject?
    @IBOutlet weak var btnTaiTrong1 : UIButton!
    @IBOutlet weak var btnTaiTrong2 : UIButton!
    @IBOutlet weak var btnTaiTrong3 : UIButton!
    
    @IBOutlet weak var btnKT1 : UIButton!
    @IBOutlet weak var btnKT2 : UIButton!
    @IBOutlet weak var btnKT3 : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentSizeInPopup  = CGSize(width: 300, height: 200)
        
        btnKT1.setImage(UIImage.init(named: "checked"), for: UIControlState.selected)
        btnKT2.setImage(UIImage.init(named: "checked"), for: UIControlState.selected)
        btnKT3.setImage(UIImage.init(named: "checked"), for: UIControlState.selected)
        
        btnKT1.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        btnKT2.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        btnKT3.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        
        btnTaiTrong1.setImage(UIImage.init(named: "checked"), for: UIControlState.selected)
        btnTaiTrong2.setImage(UIImage.init(named: "checked"), for: UIControlState.selected)
        btnTaiTrong3.setImage(UIImage.init(named: "checked"), for: UIControlState.selected)
        
        btnTaiTrong1.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        btnTaiTrong2.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        btnTaiTrong3.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
        
        btnTaiTrong1.isSelected = true
        btnTaiTrong2.isSelected = false
        btnTaiTrong3.isSelected = false
        
        btnKT1.isSelected = true
        btnKT2.isSelected = false
        btnKT3.isSelected = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        btnTaiTrong1.isSelected = true
        btnTaiTrong2.isSelected = false
        btnTaiTrong3.isSelected = false
        
        btnKT1.isSelected = true
        btnKT2.isSelected = false
        btnKT3.isSelected = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.popupController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnChooseTouchUp(_ sender : UIButton){
        switch sender {
        case btnTaiTrong1:
            btnTaiTrong1.isSelected = true
            btnTaiTrong2.isSelected = false
            btnTaiTrong3.isSelected = false
        case btnTaiTrong2:
            btnTaiTrong1.isSelected = false
            btnTaiTrong2.isSelected = true
            btnTaiTrong3.isSelected = false
        case btnTaiTrong3:
            btnTaiTrong1.isSelected = false
            btnTaiTrong2.isSelected = false
            btnTaiTrong3.isSelected = true
        case btnKT1:
            btnKT1.isSelected = true
            btnKT2.isSelected = false
            btnKT3.isSelected = false
        case btnKT2:
            btnKT1.isSelected = false
            btnKT2.isSelected = true
            btnKT3.isSelected = false
        default:
            btnKT1.isSelected = false
            btnKT2.isSelected = false
            btnKT3.isSelected = true
        }
    }
    
    @IBAction func btnDoneTouchUp(_ sender : UIButton){
        DeliveryViewController.shouldLoad = true
        var taitrong = ""
        if btnTaiTrong1.isSelected == true {
           taitrong = "5"
        } else if btnTaiTrong2.isSelected == true {
            taitrong = "10"
        } else {
            taitrong = "15"
        }
        
        var dai = ""
        var rong = ""
        var cao = ""
        
        if btnKT1.isSelected == true {
            dai = "10"
            rong = "10"
            cao = "10"
            
        } else if btnKT2.isSelected == true {
            dai = "20"
            rong = "20"
            cao = "20"
        } else {
            dai = "30"
            rong = "30"
            cao = "30"
        }
        
        let param : [String : String] = ["session" : self.getSession(),
                                         "id" : (dov?.id_don_hang.toBase64())!,
                                         "weight": taitrong.toBase64(),
                                         "size" : "\(dai)x\(rong)x\(cao)".toBase64()]
        Alamofire.request("http://www.giaohangongvang.com/api/dieuvan/sua-can-kich", method: .post, parameters: param).responseJSON { (response) in
            let data = JSON.init(data: response.data!)
            let warning = data["warning"].stringValue
            DeliveryViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
            DeliveryViewController.shouldLoad = true
            self.popupController?.dismiss(completion: {
                
            })
        }
    }
    @IBAction func btnCloseTouchUp(_ sender : UIButton){
        DeliveryViewController.shouldLoad = false
        self.popupController?.dismiss()
    }
}
