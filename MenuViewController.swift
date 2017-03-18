//
//  MenuViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/19/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire

enum MenuItem {
    case receive
    case delivery
    case receivepic
    case deliverypic
    case backto
    case purchase
    case update
    case logout
}

class ItemObj : NSObject {
    var name : String
    var img : String
    init(name : String , img : String) {
        self.name = name
        self.img = img
    }
}

class MenuViewController: BaseViewController {
    @IBOutlet weak var lblNV : UILabel!
    @IBOutlet weak var tbl : UITableView!
    let identifier = "MenuTableViewCell"
    var listItem = [ItemObj]()
    var indexPick : Int = -1
    static let sharedInstace = MenuViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        tbl.tableFooterView = UIView.init(frame: CGRect.zero)
        listItem.append(ItemObj(name: "Đơn nhận", img: "nhanhang"))
        listItem.append(ItemObj(name: "Đơn giao", img: "delivery"))
        listItem.append(ItemObj(name: "Chụp đơn nhận", img: "camera"))
        listItem.append(ItemObj(name: "Nhận đơn giao", img: "nhandon"))
        listItem.append(ItemObj(name: "Hàng về kho", img: "hangton"))
        listItem.append(ItemObj(name: "Thanh toán", img: "thanhtoan"))
        listItem.append(ItemObj(name: "Đăng xuất", img: "logout"))
        tbl.showsVerticalScrollIndicator = false
        tbl.separatorStyle = .none
        //tbl.selectRow(at: IndexPath.init(row: 1, section: 1), animated: true, scrollPosition: .top)        
    }
    override func viewDidAppear(_ animated: Bool) {
        let tenNV = UserDefaults.standard.value(forKey: UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.ho_ten)) as! String
        lblNV.text =  tenNV
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension MenuViewController : UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return 1
        }
        return 2
    }    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0.5))
            view.backgroundColor = UIColor.init(rgba: "#AAAAAA")
            return view
        } else {
            return UIView.init(frame: CGRect.zero)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MenuTableViewCell
        cell.lbl.text = listItem[indexPath.section * 2 + indexPath.row].name
        let imgStr = listItem[indexPath.section * 2 + indexPath.row].img
        cell.img.image = UIImage(named: imgStr)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = indexPath.section * 2 + indexPath.row
        if index < 6 {
            UserDefaults.standard.set(index, forKey: "Identify")
        }
        
        if index != 7 {
            MainViewController.sharedInstance.slideMenu?.slideMenuController()?.closeLeft()
        }
        let item = listItem[indexPath.section * 2 + indexPath.row]
        MainViewController.sharedInstance.lblTitle.text = item.name
        if MenuViewController.sharedInstace.indexPick != 0 {
            ReceiveViewController.shouldLoad = false
        } else if MenuViewController.sharedInstace.indexPick != 1{
            DeliveryViewController.shouldLoad = false
        }
        switch index {
        case 0:
            NotificationCenter.default.post(Notification(name: Notification.Name.init("UpdateReceiveVC")))
            MainViewController.sharedInstance.slideMenu?.mainViewController = ReceiveViewController.sharedInstance
            if MenuViewController.sharedInstace.indexPick == index {
                
            }
        case 1:
            NotificationCenter.default.post(Notification(name: Notification.Name.init("DeliveryVC")))
            MainViewController.sharedInstance.slideMenu?.mainViewController = DeliveryViewController.sharedInstance
            if MenuViewController.sharedInstace.indexPick == index {
                
            }            
        case 2:
            MainViewController.sharedInstance.slideMenu?.mainViewController = ReceiveTakePicViewController.sharedInstance
        case 3:
            MainViewController.sharedInstance.slideMenu?.mainViewController = NhanDonGiaoViewController.sharedInstance
        case 4:
            MainViewController.sharedInstance.slideMenu?.mainViewController = HangVeKhoViewController.sharedInstance
        case 5:
            MainViewController.sharedInstance.slideMenu?.mainViewController = PurchaseViewController.sharedInstance
        default:
            self.showLoadingHUD()
            
            let param : [String : String] = ["session" : self.getSession()]
            Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/logout", method: .post, parameters: param).responseJSON(completionHandler: { (response) in
                UserDefaults.standard.removeObject(forKey: "session")
                self.hideLoadingHUD()
                if response.response?.statusCode == 200 {
                    let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = loginVC
                }
            })
        }
        MenuViewController.sharedInstace.indexPick = index
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
