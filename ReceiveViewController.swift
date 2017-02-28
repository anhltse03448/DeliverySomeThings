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
    var ten_nguoi_gui : String
    var dia_chi_nguoi_gui : String
    var sdt_nguoi_nhan : String
    var indexInDatas : Int = 0
    var count : Int = 0
    init(arr : [ReceivePerson] , count : Int , ten_nguoi_gui : String , dia_chi_nguoi_gui : String, sdt_nguoi_nhan : String) {
        self.listObj = arr
        self.count = count
        self.ten_nguoi_gui = ten_nguoi_gui
        self.dia_chi_nguoi_gui = dia_chi_nguoi_gui
        self.sdt_nguoi_nhan = sdt_nguoi_nhan
    }
}

class ReceiveViewController: BaseViewController {
    let identifier = "ReceiveTableViewCell"
    let identifierTapped = "ReceiveDetailTableViewCell"
    var selectedIndexPaths = [IndexPath]()
    static let sharedInstance = ReceiveViewController()
     var listReceive = [ReceivePerson]()
    var listShow = [ShowReceive]()
    static var shouldLoad : Bool = true
    var listData : [Any] = []
    var listChecked : [Bool] = []
    var indexHeader : Int = -1
    var listHeader : [ShowReceive] = []
    var listDisplay : [Any] = []
    
    var headerSelected : ShowReceive?
    
    @IBOutlet weak var tbl : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        tbl.register(UINib.init(nibName: identifierTapped, bundle: nil), forCellReuseIdentifier: identifierTapped)
        tbl.tableFooterView = UIView.init(frame: CGRect.zero)
        tbl.estimatedRowHeight = 100
        tbl.rowHeight = UITableViewAutomaticDimension
        NotificationCenter.default.addObserver(self, selector: #selector(ReceiveViewController.receiveNotify(_:)), name: NSNotification.Name.init("UpdateReceiveVC"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    override func viewDidAppear(_ animated: Bool) {
        if ReceiveViewController.shouldLoad == false {
            tbl.reloadData()            
            //ReceiveViewController.shouldLoad = true
        } else {
            
                self.reloadData()
            
        }
    }
    
    func receiveNotify(_ notification : Notification) {
        self.reloadData()
    }
    
    func reloadData() {
        self.tbl.scrollsToTop = true
        indexHeader = -1
        self.headerSelected = nil
        self.selectedIndexPaths.removeAll()
        self.showLoadingHUD()
        let param : [String : String] = ["session" : self.getSession()]
        var tmp = [ReceivePerson]()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/list-donhang-nhan", method: .post, parameters: param).responseJSON { (response) in
                
                if response.data != nil {
                    let json = JSON(data: response.data!)
                    let datas = json["detail"].arrayValue
                    NSLog("\(json)")
                    if datas.count != 0 {
                        for item in datas {
                            let rcPerson = ReceivePerson(json: item)
                            tmp.append(rcPerson)
                        }
                        self.listReceive = tmp
                        self.solveValue()
                        NotificationCenter.default.post(Notification(name: Notification.Name.init("UpdateReceive")))
                    } else {
                        self.listReceive = tmp
                        self.solveValue()
                        let status = json["status"].stringValue
                        if status != "success" {
                            let warning = json["warning"].stringValue
                            self.view.makeToast(warning, duration: 2.0, position: .center)
                        } else {
                            
                        }
                    }
                } else {
                    self.listReceive = tmp
                    self.solveValue()
                    self.view.makeToast("Kết nối thất bại. Vui lòng liên hệ với quản trị viên", duration: 2.0, position: .center)
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func solveValue() {
        self.hideLoadingHUD()
        ReceiveViewController.sharedInstance.listShow.removeAll()
        for item in listReceive {
            var added : Bool = false
            for group in ReceiveViewController.sharedInstance.listShow {
                for itemGroup in group.listObj! {
                    if (item.id_khach_hang == itemGroup.id_khach_hang) && ( item.id_nguoi_gui == itemGroup.id_nguoi_gui) {
                        group.listObj?.append(item)
                        group.count = group.count + 1
                        added = true
                        break
                    }
                }
            }
            if added == false {
//                ReceiveViewController.sharedInstance.listShow.append(ShowReceive(arr: [item],count : [item].count))
                ReceiveViewController.sharedInstance.listShow.append(ShowReceive(arr: [item], count: [item].count, ten_nguoi_gui: item.ten_nguoi_gui, dia_chi_nguoi_gui: item.dia_chi_nguoi_gui, sdt_nguoi_nhan: item.sdt_nguoi_nhan))
            }
        }
        self.listData.removeAll()
        self.listDisplay.removeAll()
        self.listChecked.removeAll()
        
        for item in ReceiveViewController.sharedInstance.listShow {
            item.indexInDatas = listData.count
            self.listDisplay.append(item)
            self.listChecked.append(true)
            self.listData.append(item) //ShowReceive
            if item.listObj != nil {
                for item2 in item.listObj! {
                    self.listData.append(item2)
                }
            }
        }
        
        for item in ReceiveViewController.sharedInstance.listShow {
            item.listObj?.removeAll()
        }
        ReceiveViewController.sharedInstance.listShow.removeAll()
        DispatchQueue.main.async {
            self.tbl.reloadData()
            self.tbl.beginUpdates()
            self.tbl.endUpdates()
            
        }
    }
    
    @IBAction func chuyendon(_ sender : UIButton) {
        sender.isUserInteractionEnabled = false
        if indexHeader != -1 {
            var list = ""
            var count = 0
            for i in 0 ..< self.listDisplay.count {
                let item = self.listDisplay[i]
                if ( ( item as? ReceivePerson) != nil ) {
                    if listChecked[i] == true {
                        count = count + 1
                        let a = item as! ReceivePerson
                        if list == "" {
                            list = "\(a.id_don_hang)"
                        } else {
                            
                            list = list + ",\(a.id_don_hang)"
                        }
                    }
                }
            }
            if count == 0 {
                self.view.makeToast("Chọn đơn hàng", duration: 2.0, position: .center)
                sender.isUserInteractionEnabled = true
                return
            }

            if count == 0 {
                self.view.makeToast("Chọn đơn hàng", duration: 2.0, position: .center)
                sender.isUserInteractionEnabled = true
                return
            }
            
            let chuyenDonVC = ChuyenDonViewController(nibName: "ChuyenDonViewController", bundle: nil)
            let stpopup = STPopupController(rootViewController: chuyenDonVC)
            let b  = headerSelected
            sender.isUserInteractionEnabled = true
            chuyenDonVC.count = count
            chuyenDonVC.nameShop = (b?.ten_nguoi_gui)! 
            chuyenDonVC.list = list
            stpopup.present(in: self)
        } else {
            self.view.makeToast("Chọn đi rồi ấn", duration: 2.0, position: .center)
            sender.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func nhandon(_ sender : UIButton) {
        sender.isUserInteractionEnabled = false
        if indexHeader != -1 {
            var list = ""
            var count = 0
            for i in 0 ..< self.listDisplay.count {
                let item = self.listDisplay[i]
                if ( ( item as? ReceivePerson) != nil ) {
                    if listChecked[i] == true {
                            count = count + 1
                            let a = item as! ReceivePerson
                            if list == "" {
                                list = "\(a.id_don_hang)"
                            } else {
                                
                            list = list + ",\(a.id_don_hang)"
                        }
                    }
                }
            }
            if count == 0 {
                self.view.makeToast("Chọn đơn hàng", duration: 2.0, position: .center)
                sender.isUserInteractionEnabled = true
                return
            }
            let param : [String : String] = ["session" : self.getSession(),
                                             "list": list.toBase64()]
            Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/nhan-donhang", method: .post, parameters: param).responseJSON { (response) in
                let data = JSON.init(data: response.data!)
                let warning = data["warning"].stringValue
                self.view.makeToast(warning, duration: 2.0, position: .center)
                self.reloadData()
                sender.isUserInteractionEnabled = true
                NotificationCenter.default.post(Notification(name: Notification.Name.init("UpdateReceive")))
            }
        } else {
            self.view.makeToast("Chọn đi rồi ấn", duration: 2.0, position: .center)
            sender.isUserInteractionEnabled = true
        
        }
    }
    @IBAction func huydon(_ sender : UIButton){
        sender.isUserInteractionEnabled = false
        if indexHeader != -1 {
            
            var list = ""
            var count = 0
            for i in 0 ..< self.listDisplay.count {
                let item = self.listDisplay[i]
                if ( ( item as? ReceivePerson) != nil ) {
                    if listChecked[i] == true {
                        count = count + 1
                        let a = item as! ReceivePerson
                        if list == "" {
                            list = "\(a.id_don_hang)"
                        } else {
                            
                            list = list + ",\(a.id_don_hang)"
                        }
                    }
                }
            }
            if count == 0 {
                self.view.makeToast("Chọn đơn hàng", duration: 2.0, position: .center)
                sender.isUserInteractionEnabled = true
                return
            }
            if count == 0 {
                self.view.makeToast("Chọn đơn hàng", duration: 2.0, position: .center)
                sender.isUserInteractionEnabled = true
                return
            }
            
            let huydonVC = HuyDonViewController(nibName: "HuyDonViewController", bundle: nil)
            let stpopup = STPopupController(rootViewController: huydonVC)
            let b  = headerSelected
            sender.isUserInteractionEnabled = true
            huydonVC.count = count
            huydonVC.nameShop = (b?.ten_nguoi_gui)!
            huydonVC.list = list
            stpopup.present(in: self)
        } else {
            sender.isUserInteractionEnabled = true
            self.view.makeToast("Chọn đi rồi ấn", duration: 2.0, position: .center)
        }
    }
    
    func addValue(start : Int) {
        if start == -1 {
            var tmp : [Any] = []
            
            for i in 0 ..< self.listData.count {
                let item = listData[i]
                if ((item as? ShowReceive) != nil) {
                    tmp.append(item)
                }
            }
            listChecked.removeAll()
            for _ in tmp {
                listChecked.append(true)
            }
            self.listDisplay = tmp
            tbl.reloadData()
            return
        }
        var tmp : [Any] = []
        for i in 0 ..< start+1 {
            let item = listData[i]
            if ((item as? ShowReceive) != nil) {
                tmp.append(item)
            }
        }
        for i in start+1 ..< self.listData.count {
            let item = listData[i]
            if ((item as? ShowReceive) != nil) {
                for j in i ..< self.listData.count {
                    let item2 = listData[j]
                    if ((item2 as? ShowReceive) != nil) {
                        tmp.append(item2)
                    }
                }
                break
            } else {
                tmp.append(item)
            }
        }
        
        listChecked.removeAll()
        for _ in tmp {
            listChecked.append(true)
        }
        self.listDisplay = tmp
        tbl.reloadData()
    }
}
extension ReceiveViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.listDisplay.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.listDisplay[indexPath.row]
        if ((item as? ShowReceive) != nil) {
            let cell = tbl.dequeueReusableCell(withIdentifier: "ReceiveTableViewCell") as! ReceiveTableViewCell
            cell.delegate = self
            let data = item as! ShowReceive
            if checkSelectHeader(item: data) == true {
                cell.backgroundColor = UIColor.init(rgba: "#EBB003")
            } else {
                cell.backgroundColor = UIColor.clear
            }
            let content = data
            cell.lbl1.text = (content.ten_nguoi_gui) + "(\(data.count))"
            cell.lbl2.text = content.dia_chi_nguoi_gui
            return cell
        } else {
            let cell = tbl.dequeueReusableCell(withIdentifier: "ReceiveDetailTableViewCell") as! ReceiveDetailTableViewCell            
            let data = item as! ReceivePerson
            if indexHeader == -1 {
                cell.lbl1.text = ""
            } else {
                cell.lbl1.text = data.dia_chi_nhan
            }
            //cell.lbl1.text = data.dia_chi_nhan
            if listChecked[indexPath.row] == true {
                cell.btnChecked.setImage(UIImage.init(named: "checked"), for: UIControlState.normal)
            } else {
                cell.btnChecked.setImage(UIImage.init(named: "unchecked"), for: UIControlState.normal)
            }
            return cell
        }
    
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var item = self.listDisplay[indexPath.row]
        if ((item as? ShowReceive) != nil) {
            return UITableViewAutomaticDimension
        } else {
            return UITableViewAutomaticDimension
//            if indexHeader == -1 {
//                return 0
//            } else {
//                var endIndex = -1
//                //bat dau tu indexHeader + 1 -> vi tri tiep theo
//                for i in indexHeader+1 ..< self.listData.count {
//                    let item = self.listData[i]
//                    if ((item as? ShowReceive) != nil) {
//                        endIndex = i
//                        break
//                    }
//                }
//                if endIndex == -1 {
//                    endIndex = self.listData.count
//                }
//                if (( indexPath.row > indexHeader) && (indexPath.row < endIndex) ) {
//                    return UITableViewAutomaticDimension
//                } else {
//                    return 0
//                }
//            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.listDisplay[indexPath.row]
        tbl.deselectRow(at: indexPath, animated: true)
        
        if ((item as? ShowReceive) != nil) {
            self.listChecked[indexPath.row] = !self.listChecked[indexPath.row]
            let data = item as! ShowReceive
            if checkSelectHeader(item: data) {
                indexHeader = -1
                addValue(start: -1)
                headerSelected = nil
                //add data
            } else {
                let data = item as! ShowReceive
                addValue(start: data.indexInDatas)
                indexHeader = indexPath.row
                headerSelected = item as? ShowReceive
            }
            tbl.reloadData()
        } else {
            listChecked[indexPath.row] = !listChecked[indexPath.row]
            tbl.reloadData()
        }
    }
    func checkSelectHeader(item : ShowReceive) -> Bool{
        if headerSelected == nil {
            return false
        }
        if headerSelected?.ten_nguoi_gui == item.ten_nguoi_gui {
            return true
        }
        return false
    }
}

extension ReceiveViewController : ReceiveCellDelegate {
    func mapTouchUp(cell: ReceiveTableViewCell) {
        let indexpath = tbl.indexPath(for: cell)
        var dia_nhan = ""
        let item = self.listDisplay[(indexpath?.row)!]
        if ((item as? ShowReceive) != nil) {
            let data = item as! ShowReceive
            let content = data.dia_chi_nguoi_gui
            dia_nhan = content
        }
        dia_nhan = dia_nhan.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let testURL = URL(string: "comgooglemaps-x-callback://")!
        if UIApplication.shared.canOpenURL(testURL) {
            let directionsRequest = "comgooglemaps-x-callback://" +
                "?daddr=\(dia_nhan)" +
            "&&directionsmode=transit"
            
            let directionsURL = URL(string: directionsRequest)!
            UIApplication.shared.openURL(directionsURL)
        } else {
            NSLog("Can't use comgooglemaps-x-callback:// on this device.")
        }

    }
    func callTouchUp(cell: ReceiveTableViewCell) {
        let index = self.tbl.indexPath(for: cell)
        let obj = self.listDisplay[(index?.row)!] as! ShowReceive
        let phone = obj.sdt_nguoi_nhan
        guard let number = URL(string: "telprompt://" + phone) else { return }
        UIApplication.shared.openURL(number)
        //UIApplication.shared.open(number, options: [:], completionHandler: nil)
        
    }
}
