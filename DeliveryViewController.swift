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
            let height2 = item.ghi_chu.heightWithConstrainedWidth(width: width2, font: UIFont.systemFont(ofSize: 15))
            if height <= 32 {
                return CGSize.init(width: collectionView.frame.width, height: CGFloat(40 + 300 + height2))
            } else {
                return CGSize.init(width: collectionView.frame.width, height: CGFloat(height + 300 + height2))
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
        let item = self.listDeliverys?[(index?.row)!]
        
        hoandonVC = HoanDonViewController(nibName: "HoanDonViewController", bundle: nil)
        
        hoandonVC?.dov = item
        let stpopup = STPopupController(rootViewController: self.hoandonVC!)
        stpopup.present(in: self)
    }
    func hoanthanh(cell: DeliveryCollectionViewCell) {
        let index = self.tbl.indexPath(for: cell)
        let item = self.listDeliverys?[(index?.row)!]
        
            hoanthanhVC = HoanThanhViewController(nibName: "HoanThanhViewController", bundle: nil)
        
        
        hoanthanhVC?.item = item
        let stpopup = STPopupController(rootViewController: hoanthanhVC!)
        stpopup.present(in: self)
    }
    func ghichu(cell: DeliveryCollectionViewCell) {
        let index = self.tbl.indexPath(for: cell)
        let item = self.listDeliverys?[(index?.row)!]
        
            ghiChuVC = GhiChuViewController(nibName: "GhiChuViewController", bundle: nil)
        
        ghiChuVC?.dov = item
        let stpopup = STPopupController(rootViewController: ghiChuVC!)
        stpopup.present(in: self)
    }
    func call(cell: DeliveryCollectionViewCell) {
        let index = self.tbl.indexPath(for: cell)
        let phone = listDeliverys?[(index?.row)!].sdt_nguoi_nhan
        guard let number = URL(string: "telprompt://" + phone!) else { return }
        UIApplication.shared.openURL(number)
        //UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    func touchMap(cell: DeliveryCollectionViewCell) {
        let index = self.tbl.indexPath(for: cell)
        let item = self.listDeliverys?[(index?.row)!]
        var address = item?.dia_chi_nguoi_nhan ?? ""
        address = address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        if item?.dia_chi_nguoi_nhan != "" {
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
        self.tbl.scrollToItem(at: index!, at: UICollectionViewScrollPosition.top, animated: true)
        if selectedIndexPath.contains(index!) {
            let indexArr = selectedIndexPath.index(of: index!)!
            selectedIndexPath.remove(at: indexArr)
        } else {
            selectedIndexPath.append(index!)
        }
        tbl.reloadItems(at: [index!])
    }
    
}
