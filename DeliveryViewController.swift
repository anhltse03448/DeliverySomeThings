//
//  DeliveryViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/19/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import STPopup

class DeliveryViewController: UIViewController {
    @IBOutlet weak var tbl : UITableView!
    let identifierNormal = "DeliveryTableViewCell"
    let identifierTapped = "DeliveryTappedTableViewCell"
    var listDeliverys : [DeliveryObject]?
    var selectedIndexPath : IndexPath?
    static let sharedInstance = DeliveryViewController()
    
    var hoandonVC : HoanDonViewController?
    var hoanthanhVC : HoanThanhViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listDeliverys = [DeliveryObject]()
        tbl.register(UINib.init(nibName: identifierNormal, bundle: nil), forCellReuseIdentifier: identifierNormal)
        tbl.register(UINib.init(nibName: identifierTapped, bundle: nil), forCellReuseIdentifier: identifierTapped)
        self.tbl.tableFooterView = UIView.init(frame: CGRect.zero)
        loadDonGiao()
        tbl.isEditing = true
        tbl.allowsSelectionDuringEditing = true
        tbl.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDonGiao() {
        let link = "http://www.giaohangongvang.com/api/nhanvien/list-donhang-giao"
        let session = UserDefaults.standard.value(forKey: UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.session)) as! String
        let param : [String : String] = ["session" : session.toBase64()]
        Alamofire.request(link, method: .post, parameters: param).responseJSON { (response) in
            let data = JSON.init(data: response.data!)
            let detail = data["detail"]
            for item in detail.array! {
                NSLog("\(item)")
                let deo = DeliveryObject(json: item)
                self.listDeliverys?.append(deo)
                DispatchQueue.main.async {
                    self.tbl.reloadData()
                }
            }
        }
    }
}
extension DeliveryViewController : UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (listDeliverys?.count) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = listDeliverys?[indexPath.row]
        if selectedIndexPath == nil {
            let cell = tbl.dequeueReusableCell(withIdentifier: identifierNormal, for: indexPath) as! DeliveryTableViewCell
            cell.setData(deo: item!)
            return cell
        } else {
            if selectedIndexPath?.row == indexPath.row {
                let cell = tbl.dequeueReusableCell(withIdentifier: identifierTapped, for: indexPath) as! DeliveryTappedTableViewCell
                cell.delegate = self
                cell.setData(deo: item!)
                return cell
            } else { // khac nhau
                let cell = tbl.dequeueReusableCell(withIdentifier: identifierNormal, for: indexPath) as! DeliveryTableViewCell
                cell.setData(deo: item!)
                return cell
            }
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndexPath?.row == indexPath.row {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath    
        }
        DispatchQueue.main.async {
            self.tbl.beginUpdates()
            self.tbl.endUpdates()
            self.tbl.reloadData()
        }
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if selectedIndexPath == nil {
//            return 40
//        } else {
//            if selectedIndexPath?.row == indexPath.row {
//                return UITableViewAutomaticDimension
//            } else {
//                return 40
//            }
//        }
//    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
}
extension DeliveryViewController : DeliveryDelegate {
    func hoandon(cell: DeliveryTappedTableViewCell) {
        let index = self.tbl.indexPath(for: cell)
        let item = self.listDeliverys?[(index?.row)!]
        if hoandonVC == nil {
            hoandonVC = HoanDonViewController(nibName: "HoanDonViewController", bundle: nil)
        }
        let stpopup = STPopupController(rootViewController: self.hoandonVC!)
        stpopup.present(in: self)
    }
    func hoanthanh(cell: DeliveryTappedTableViewCell) {
        let index = self.tbl.indexPath(for: cell)
        let item = self.listDeliverys?[(index?.row)!]
        let hoanthanhpopupVC = HoanThanhViewController(nibName: "HoanThanhViewController", bundle: nil)
        hoanthanhpopupVC.item = item
        let stpopup = STPopupController(rootViewController: hoanthanhpopupVC)
        stpopup.present(in: self)
    }
    func ghichu(cell: DeliveryTappedTableViewCell) {
        let index = self.tbl.indexPath(for: cell)
        let item = self.listDeliverys?[(index?.row)!]
        let ghichuVC = GhiChuViewController(nibName: "", bundle: nil)
        let stpopup = STPopupController(rootViewController: ghichuVC)
        stpopup.present(in: self)
    }
    func call(cell: DeliveryTappedTableViewCell) {
        let index = self.tbl.indexPath(for: cell)
        let phone = listDeliverys?[(index?.row)!].sdt_nguoi_nhan
        guard let number = URL(string: "telprompt://" + phone!) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
}
