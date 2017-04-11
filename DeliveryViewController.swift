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

class DeliveryViewController: BaseViewController {
    @IBOutlet weak var tbl : UICollectionView!
    @IBOutlet weak var btnShort : UIButton!
    let identifierNormal = "DeliveryCollectionViewCell"
    var listDeliverys : [DeliveryObject]?
    
    static let sharedInstance = DeliveryViewController()
    
    var hoandonVC : HoanDonViewController?
    var hoanthanhVC : HoanThanhViewController?
    var ghiChuVC : GhiChuViewController?
    
    var selectedIndexPath = [IndexPath]()
    static var shouldLoad : Bool = true
    
    var arrOrder = [String]()
    var listShowOnly = [DeliveryObject]()
    var listIdsort = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listDeliverys = [DeliveryObject]()
        let cellNib = UINib.init(nibName: identifierNormal, bundle: nil)
        self.tbl.register(cellNib, forCellWithReuseIdentifier: identifierNormal)
        self.tbl.dataSource = self
        self.tbl.delegate = self
        //tbl.register(UINib.init(nibName: identifierNormal, bundle: nil), forCellWithReuseIdentifier: identifierNormal)
        NotificationCenter.default.addObserver(self, selector: #selector(DeliveryViewController.receiveNotify(_:)), name: NSNotification.Name.init("DeliveryVC"), object: nil)
        
        
        self.tbl.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(DeliveryViewController.handleLongGesture(gesture:))))
    }
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.tbl.indexPathForItem(at: gesture.location(in: self.tbl)) else {
                break
            }
            if #available(iOS 9.0, *) {
                tbl.beginInteractiveMovementForItem(at: selectedIndexPath)
            } else {
                // Fallback on earlier versions
            }
        case UIGestureRecognizerState.changed:
            if #available(iOS 9.0, *) {
                tbl.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            } else {
                // Fallback on earlier versions
            }
        case UIGestureRecognizerState.ended:
            if #available(iOS 9.0, *) {
                tbl.endInteractiveMovement()
                tbl.reloadData()
            } else {
                // Fallback on earlier versions
            }
        default:
            if #available(iOS 9.0, *) {
                tbl.cancelInteractiveMovement()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        if DeliveryViewController.shouldLoad == true {
            self.selectedIndexPath.removeAll()
            
            self.loadDonGiao()
            
        } else {
            //
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        //        if DeliveryViewController.shouldLoad == true {
        //            self.loadDonGiao()
        //        } else {
        //        }
    }
    
    func receiveNotify(_ notification : Notification) {
        self.loadDonGiao()
    }
    
    func loadDonGiao() {
        DeliveryViewController.shouldLoad = false
        self.showLoadingHUD()
        let link = "http://www.giaohangongvang.com/api/nhanvien/list-donhang-giao"
        let param : [String : String] = ["session" : self.getSession()]
        var tmp = [DeliveryObject]()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            Alamofire.request(link, method: .post, parameters: param).responseJSON { (response) in
                if response.data == nil {
                    self.hideLoadingHUD()
                    return
                }
                let data = JSON.init(data: response.data!)
                self.hideLoadingHUD()
                let detail = data["detail"]
                
                if detail.array != nil {
                    for item in detail.array! {
                        let deo = DeliveryObject(json: item)
                        tmp.append(deo)
                        //self.listDeliverys?.append(deo)
                    }
                    self.listDeliverys = tmp
                    
                    self.listShowOnly = self.processDataOrder() //showonly
                    self.saveOrderData()
                    
                    DispatchQueue.main.async {
                        self.tbl.reloadData()
                    }
                    
                    self.hideLoadingHUD()
                    
                } else {
                    self.hideLoadingHUD()
                    let status = data["status"].stringValue
                    if status != "success" {
                        let warning = data["warning"].stringValue
                        self.view.makeToast(warning, duration: 2.0, position: .center)
                    }
                    DispatchQueue.main.async {
                        self.tbl.reloadData()
                    }
                    self.listDeliverys = tmp
                    
                    
                    self.listShowOnly = self.processDataOrder()  //show only
                    self.saveOrderData()
                }
            }
        }
    }
    
    @IBAction func reorder(_sender : UIButton){
        callRequestReorder()
    }
    
    func callRequestReorder() {
        let bodyStr = "{\"session_key\": \"\",\"employees\": \"1\",\"depot\": {\"address\": \"\",\"latitude\": 21.0167407,\"longitude\": 105.8375174},\"orders\": [{\"id\": \"20838\",\"address\": \"152 Đê Tô Hoàng, Hai Bà Trưng[Hà Nội gần], Hai Bà Trưng, Hà Nội\"}, {\"id\": \"20839\",\"address\": \"số nhà 16 ngõ 362/29 phố Nam Dư, Hoàng Mai[Hà Nội gần], Hoàng Mai, Hà Nội\"}, {\"id\": \"20847\",\"address\": \"Số 7 hào nam , Hoàn Kiếm, \"}, {\"id\": \"20851\",\"address\": \"sdsds, Hoàn Kiếm, Hà Nội\"}, {\"id\": \"20848\",\"address\": \"(n) 27 tổ 36 ngách 107/176 lĩnh nam, hoàng mai, hn, Hoàng Mai, Hà Nội\"}, {\"id\": \"20849\",\"address\": \"(m) 1b Trần Thánh Tông, Phạm Đình Hổ, Hai Bà Trưng, Hà Nội, Hai Bà Trưng, Hà Nội\"}]}"
        
        var tmp = ""
        for i in 0 ..< self.listShowOnly.count {
            let item = self.listShowOnly[i]
            if (i == self.listShowOnly.count - 1) {
                tmp = tmp + item.toString()
            } else {
                tmp = tmp + item.toString() + ","
            }
        }
        
        let order = "\"orders\" : [\(tmp)]"
        let session_key = "\"session_key\" : \"\(self.getSession())\""
        
        let lat = UserDefaults.standard.value(forKey: UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.lat)) as? String ?? ""
        
        let lon = UserDefaults.standard.value(forKey: UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.long)) as? String ?? ""
        
        let tmpDepot = "\"address\" : \"\",\"latitude\" : \(lat),\"longitude\" : \(lon)"
        let depot = "\"depot\" : {\(tmpDepot)}"
        let employeeStr = "\"employees\" : \"\(1)\""
        
        let bodyStrReal = "{\(session_key),\(employeeStr),\(depot),\(order)}"
        self.showLoadingHUD()
        Alamofire.request("http://137.74.174.141:16005/api/v1/tsp/ongvang_nhanvien", method: .post, parameters: nil, encoding: bodyStrReal, headers: nil).responseJSON { (response) in
            let data = JSON.init(data: response.data!)
            let orders = data["solution"]["orders"]
            NSLog("\(orders)")
            for item in orders.arrayValue {
                let id = item["id_order"].stringValue
                self.listIdsort.append(id)
            }
            
            var listTmp = [DeliveryObject]()
            for i in ( 0 ..< self.listIdsort.count).reversed() {
                let item = self.listIdsort[i]
                var ok = false
                for item1 in self.listShowOnly {
                    if item == item1.id_don_hang {
                        listTmp.insert(item1, at: 0)
                        ok = true
                        break
                    }
                    if ok == false {
                        listTmp.append(item1)
                    }
                }
            }
            self.listShowOnly = listTmp
            self.saveOrderData()
            self.hideLoadingHUD()
            DispatchQueue.main.async {
                self.tbl.reloadData()
            }
        }
    }
}
extension DeliveryViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(70,listShowOnly.count)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierNormal, for: indexPath) as! DeliveryCollectionViewCell
        
        //cell.imgChuyen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DeliveryViewController.handleLongGesture(gesture:))))
        
        cell.setData(item: (listShowOnly[indexPath.row]))
        cell.delegate = self
        if selectedIndexPath.contains(indexPath) {
            cell.viewTop.backgroundColor = UIColor.init(rgba: "#EBB003")
        } else {
            cell.viewTop.backgroundColor = UIColor.clear
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if selectedIndexPath.contains(indexPath) {
            let item = listShowOnly[indexPath.row]
            let width = collectionView.frame.width - 42
            let height = item.dia_chi_nguoi_nhan.heightWithConstrainedWidth(width: width, font: UIFont.systemFont(ofSize: 15))//50
            
            let width2 = collectionView.frame.width - 50
            let ghi_chu = item.ghi_chu.replacingOccurrences(of: "\\n", with: "\n")
            let height2 = ghi_chu.heightWithConstrainedWidth(width: width2, font: UIFont.systemFont(ofSize: 15))
            if height <= 32 {
                return CGSize.init(width: collectionView.frame.width, height: CGFloat(40 + 300 + height2))
            } else {
                return CGSize.init(width: collectionView.frame.width, height: CGFloat(height + 8 + 300 + height2))
            }
        } else {
            let item = listShowOnly[indexPath.row]
            let width = collectionView.frame.width - 42
            let height = item.dia_chi_nguoi_nhan.heightWithConstrainedWidth(width: width, font: UIFont.systemFont(ofSize: 15))
            if height <= 32 {
                return CGSize.init(width: collectionView.frame.width, height: 40)
            } else {
                return CGSize.init(width: collectionView.frame.width, height: CGFloat(height + 8 ))
            }
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let obj = listShowOnly.remove(at: sourceIndexPath.row)
        listShowOnly.insert(obj, at: destinationIndexPath.row)
        saveOrderData()
    }
    
    func processDataOrder() -> [DeliveryObject]{
        var tmp : [DeliveryObject?] = []
        let orderData = getOrderData()
        for _ in orderData {
            tmp.append(nil)
        }
        //var tmp : [DeliveryObject] = Array<DeliveryObject>.init(repeating: nil, count: orderData.count)
        if orderData.count == 0 {
            return self.listDeliverys!
        }
        for item2 in self.listDeliverys! {
            let idDonHang = item2.id_don_hang
            if orderData.contains(idDonHang) {
                let pos = orderData.index(of: idDonHang)
                tmp[pos!] = item2
            } else {
                tmp.append(item2)
            }
        }
//        for i in 0 ..< tmp.count {
//            if i < tmp.count {
//                if tmp[i] == nil {
//                    tmp.remove(at: i)
//                }
//            }
//        }
        var i = 0
        while i < tmp.count {
            if i < tmp.count {
                if tmp[i] == nil {
                    tmp.remove(at: i)
                } else {
                    i = i + 1
                }
            } else {
                break
            }
        }
        return tmp as! [DeliveryObject]
    }
    
    func getOrderData() -> [String] {
        let tmp = UserDefaults.standard.value(forKey: "OrderDonGiao")
        if tmp != nil {
            let arr = tmp as? [String]
            if arr != nil {
                return arr!
            } else {
                return []
            }
        } else {
            return []
        }
    }
    
    func saveOrderData(){
        var tmp = [String]()
        for item in self.listShowOnly {
            let id = item.id_don_hang
            tmp.append(id)
        }
        UserDefaults.standard.set(tmp, forKey: "OrderDonGiao")
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
extension DeliveryViewController : DeliveryDelegate {
    func hoandon(cell: DeliveryCollectionViewCell) {
        let index = self.tbl.indexPath(for: cell)
        let item = self.listShowOnly[(index?.row)!]
        
        hoandonVC = HoanDonViewController(nibName: "HoanDonViewController", bundle: nil)
        
        hoandonVC?.dov = item
        let stpopup = STPopupController(rootViewController: self.hoandonVC!)
        stpopup.present(in: self)
    }
    func hoanthanh(cell: DeliveryCollectionViewCell) {
        let index = self.tbl.indexPath(for: cell)
        let item = self.listShowOnly[(index?.row)!]
        
            hoanthanhVC = HoanThanhViewController(nibName: "HoanThanhViewController", bundle: nil)
        
        
        hoanthanhVC?.item = item
        let stpopup = STPopupController(rootViewController: hoanthanhVC!)
        stpopup.present(in: self)
    }
    func ghichu(cell: DeliveryCollectionViewCell) {
        let index = self.tbl.indexPath(for: cell)
        let item = self.listShowOnly[(index?.row)!]
        
            ghiChuVC = GhiChuViewController(nibName: "GhiChuViewController", bundle: nil)
        
        ghiChuVC?.dov = item
        let stpopup = STPopupController(rootViewController: ghiChuVC!)
        stpopup.present(in: self)
    }
    func call(cell: DeliveryCollectionViewCell) {
        let index = self.tbl.indexPath(for: cell)
        let phone = listShowOnly[(index?.row)!].sdt_nguoi_nhan
        guard let number = URL(string: "telprompt://" + phone) else { return }
        UIApplication.shared.openURL(number)
        //UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    func touchMap(cell: DeliveryCollectionViewCell) {
        let index = self.tbl.indexPath(for: cell)
        let item = self.listShowOnly[(index?.row)!]
        var address = item.dia_chi_nguoi_nhan ?? ""
        address = address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        if item.dia_chi_nguoi_nhan != "" {
            let testURL = URL(string: "comgooglemaps-x-callback://")!
            if UIApplication.shared.canOpenURL(testURL) {
                let directionsRequest = "comgooglemaps-x-callback://" +
                    "?daddr=\(address)" +
                "&&directionsmode=transit"
                let directionsURL = URL(string: directionsRequest)!
                UIApplication.shared.openURL(directionsURL)
            } else {
                NSLog("Can't use comgooglemaps-x-callback:// on this device.")
            }
        } else {
            self.view.makeToast("ko có địa chỉ nhận", duration: 2.0, position: .center)
        }
    }
    func expandse(cell: DeliveryCollectionViewCell) {
        let index = self.tbl.indexPath(for: cell)
        if selectedIndexPath.contains(index!) {
            let indexArr = selectedIndexPath.index(of: index!)!
            selectedIndexPath.remove(at: indexArr)
            tbl.reloadData()
        } else {
            selectedIndexPath.removeAll()
            selectedIndexPath.append(index!)
            tbl.reloadData()
            self.tbl.scrollToItem(at: index!, at: UICollectionViewScrollPosition.top, animated: true)
        }
        //tbl.reloadItems(at: [index!])
        
    }
}
extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
