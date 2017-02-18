//
//  ReceiveViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/19/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import STPopup

class ShowReceive : NSObject {
    var listObj : [ReceivePerson]?
    var listChecked : [Bool]?
    init(arr : [ReceivePerson]) {
        self.listObj = arr
        listChecked = [Bool]()
        if listObj != nil {
            for _ in 0 ..< listObj!.count {
                listChecked?.append(true)
            }
        }
    }
}

class ReceiveViewController: BaseViewController {
    let identifier = "ReceiveTableViewCell" ;
    let identifierTapped = "ReceiveTappedTableViewCell"
    var selectedIndexPaths = [IndexPath]()
    static let sharedInstance = ReceiveViewController()
     var listReceive = [ReceivePerson]()
    var listShow = [ShowReceive]()
    static var shouldLoad : Bool = true
    
    @IBOutlet weak var tbl : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        tbl.register(UINib.init(nibName: identifierTapped, bundle: nil), forCellReuseIdentifier: identifierTapped)
        tbl.separatorStyle = .none
        tbl.rowHeight = UITableViewAutomaticDimension
        NotificationCenter.default.addObserver(self, selector: #selector(ReceiveViewController.receiveNotify(_:)), name: NSNotification.Name.init("UpdateReceiveVC"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ReceiveViewController.shouldLoad == false {
            
        } else {
            ReceiveViewController.shouldLoad = true
            self.reloadData()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tbl.reloadData()
    }
    
    func receiveNotify(_ notification : Notification) {
        self.reloadData()
    }
    
    func reloadData() {
        let session = UserDefaults.standard.value(forKey: UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.session))
        let sessionBase64 = (session as! String).toBase64()
        let param : [String : String] = ["session" : sessionBase64]
        var tmp = [ReceivePerson]()
        Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/list-donhang-nhan", method: .post, parameters: param).responseJSON { (response) in
            if response.data != nil {
                let json = JSON(data: response.data!)
                let datas = json["detail"].arrayValue
                if datas.count != 0 {
                    for item in datas {
                        let rcPerson = ReceivePerson(json: item)
                        tmp.append(rcPerson)
                    }
                    self.listReceive = tmp
                    self.solveValue()
                    if self.tbl != nil {
                        self.tbl.reloadData()
                        NotificationCenter.default.post(Notification(name: Notification.Name.init("UpdateReceive")))
                    }
                } else {
                    let status = json["status"].stringValue
                    if status != "success" {
                        let warning = json["warning"].stringValue
                        self.view.makeToast(warning, duration: 2.0, position: .center)
                        ReceiveViewController.sharedInstance.listShow.removeAll()
                        self.tbl.reloadData()
                    }
                }
            } else {
                self.view.makeToast("Kết nối thất bại. Vui lòng liên hệ với quản trị viên", duration: 2.0, position: .center)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func solveValue() {
        ReceiveViewController.sharedInstance.listShow.removeAll()
        for item in listReceive {
            var added : Bool = false
            for group in ReceiveViewController.sharedInstance.listShow {
                for itemGroup in group.listObj! {
                    if (item.id_khach_hang == itemGroup.id_khach_hang) && ( item.id_nguoi_gui == itemGroup.id_nguoi_gui) {
                        group.listObj?.append(item)
                        group.listChecked?.append(true)
                        added = true
                        break
                    }
                }
            }
            if added == false {
                ReceiveViewController.sharedInstance.listShow.append(ShowReceive(arr: [item]))
            }
        }
        
        DispatchQueue.main.async {
            self.tbl.reloadData()
        }
    }
    
    @IBAction func chuyendon(_ sender : UIButton) {
        if selectedIndexPaths.count == 1 {
            
            var list = ""
            let a = selectedIndexPaths[0].row
            if ReceiveViewController.sharedInstance.listShow[a].listChecked == nil {
                self.view.makeToast("Chọn đi rồi ấn", duration: 2.0, position: .center)
                return
            }
            var count = 0
            
            for i in 0 ..< ReceiveViewController.sharedInstance.listShow[a].listChecked!.count {
                let item = ReceiveViewController.sharedInstance.listShow[a].listChecked![i]
                if item == true {
                    let io = ReceiveViewController.sharedInstance.listShow[a].listObj
                    let id = io?[i].id_don_hang ?? ""
                    if list == "" {
                        list = "\(id)"
                    } else {
                        list = list + ",\(id)"
                    }
                    count = count + 1
                }
            }
            
            let chuyenDonVC = ChuyenDonViewController(nibName: "ChuyenDonViewController", bundle: nil)
            let stpopup = STPopupController(rootViewController: chuyenDonVC)
            let b  = ReceiveViewController.sharedInstance.listShow[a].listObj?[0]
            
            chuyenDonVC.count = count
            chuyenDonVC.nameShop = (b?.ten_nguoi_gui) ?? ""
            chuyenDonVC.list = list
            stpopup.present(in: self)
        } else {
            self.view.makeToast("Chọn đi rồi ấn", duration: 2.0, position: .center)
        }

    }
    
    @IBAction func nhandon(_ sender : UIButton) {
        if selectedIndexPaths.count == 1 {
            
            let a = selectedIndexPaths[0].row
            if ReceiveViewController.sharedInstance.listShow[a].listChecked == nil {
                self.view.makeToast("Chọn đi rồi ấn", duration: 2.0, position: .center)
            }
            var list = ""
            for i in 0 ..< ReceiveViewController.sharedInstance.listShow[a].listChecked!.count {
                let item = ReceiveViewController.sharedInstance.listShow[a].listChecked![i]
                if item == true {
                    let io = ReceiveViewController.sharedInstance.listShow[a].listObj
                    let id = io?[i].id_don_hang ?? ""
                    if list == "" {
                        list = "\(id)"
                    } else {
                        list = list + ",\(id)"
                    }
                }
            }
            let param : [String : String] = ["session" : self.getSession(),
                                             "list": list.toBase64()]
            Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/nhan-donhang", method: .post, parameters: param).responseJSON { (response) in
                let data = JSON.init(data: response.data!)
                let warning = data["warning"].stringValue
                self.view.makeToast(warning, duration: 2.0, position: .center)
                self.reloadData()
                NotificationCenter.default.post(Notification(name: Notification.Name.init("UpdateReceive")))
            }
        } else {
            self.view.makeToast("Chọn đi rồi ấn", duration: 2.0, position: .center)
        }
    }
    @IBAction func huydon(_ sender : UIButton){
        if selectedIndexPaths.count == 1 {
            
            var list = ""
            let a = selectedIndexPaths[0].row
            if ReceiveViewController.sharedInstance.listShow[a].listChecked == nil {
                self.view.makeToast("Chọn đi rồi ấn", duration: 2.0, position: .center)
                return
            }
            var count = 0
            
            for i in 0 ..< ReceiveViewController.sharedInstance.listShow[a].listChecked!.count {
                let item = ReceiveViewController.sharedInstance.listShow[a].listChecked![i]
                if item == true {
                    let io = ReceiveViewController.sharedInstance.listShow[a].listObj
                    let id = io?[i].id_don_hang ?? ""
                    if list == "" {
                        list = "\(id)"
                    } else {
                        list = list + ",\(id)"
                    }
                    count = count + 1
                }
            }
            
            let huydonVC = HuyDonViewController(nibName: "HuyDonViewController", bundle: nil)
            let stpopup = STPopupController(rootViewController: huydonVC)
            let b  = ReceiveViewController.sharedInstance.listShow[a].listObj?[0]
            
            huydonVC.count = count
            huydonVC.nameShop = (b?.ten_nguoi_gui) ?? ""
            huydonVC.list = list
            stpopup.present(in: self)
        } else {
            self.view.makeToast("Chọn đi rồi ấn", duration: 2.0, position: .center)
        }
    }
}
extension ReceiveViewController : UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = ReceiveViewController.sharedInstance.listShow[indexPath.row].listObj?[0]
        
            let cell = tbl.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ReceiveTableViewCell
            let count = ReceiveViewController.sharedInstance.listShow[indexPath.row].listObj?.count
            cell.setData(rcp: item!, count: count!)
            cell.delegate = self
            if selectedIndexPaths.contains(indexPath) {
                cell.viewTop.backgroundColor = UIColor.init(rgba: "#EBB003")
            } else {
                cell.viewTop.backgroundColor = UIColor.clear
            }
            return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReceiveViewController.sharedInstance.listShow.count
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tbl.deselectRow(at: indexPath, animated: true)
        let cell = tbl.cellForRow(at: indexPath) as! ReceiveTableViewCell
        
        
        if selectedIndexPaths.contains(indexPath) {
            selectedIndexPaths.removeAll()
        } else {
            selectedIndexPaths.removeAll()
            selectedIndexPaths.append(indexPath)
            cell.indexCell = indexPath.row
            NotificationCenter.default.post(Notification(name: Notification.Name.init("UpdateReceive")))
        }
        self.tbl.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count = ReceiveViewController.sharedInstance.listShow[indexPath.row].listObj?.count
        if selectedIndexPaths.contains(indexPath) {
            return CGFloat(55) + min(CGFloat(count!) * CGFloat(60) + 20, 600)
        } else {
            return 55
        }
    }
}
extension ReceiveViewController : ReceiveCellDelegate {
    func mapTouchUp(cell: ReceiveTableViewCell) {
        
    }
    func callTouchUp(cell: ReceiveTableViewCell) {
        let index = self.tbl.indexPath(for: cell)
        let obj = ReceiveViewController.sharedInstance.listShow[(index?.row)!].listObj?[0]
        let phone = obj?.sdt_nguoi_nhan
        guard let number = URL(string: "telprompt://" + phone!) else { return }
        UIApplication.shared.openURL(number)
        //UIApplication.shared.open(number, options: [:], completionHandler: nil)
        
    }
}
