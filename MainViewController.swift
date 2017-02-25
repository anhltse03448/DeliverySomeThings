//
//  MainViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/19/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import STPopup

class MainViewController: UIViewController {
    @IBOutlet weak var btnMenu : UIButton!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var hotlineIcon : UIImageView!
    
    static let sharedInstance = MainViewController()
    var slideMenu : SlideMenuController?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let menuVC = MenuViewController(nibName: "MenuViewController", bundle: nil)
        let receiveVC = ReceiveViewController(nibName: "ReceiveViewController", bundle: nil)
        let slideMenu = SlideMenuController(mainViewController: receiveVC, leftMenuViewController: menuVC)
        slideMenu.view.frame = mainView.bounds
        mainView.addSubview(slideMenu.view)
        addChildViewController(slideMenu)
        slideMenu.didMove(toParentViewController: self)
        MainViewController.sharedInstance.slideMenu = slideMenu
        MainViewController.sharedInstance.lblTitle = self.lblTitle
        self.lblTitle.text = "Đơn Nhận"
        let notificationName = Notification.Name("TakePicture")
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.takePicture(notify:)), name: notificationName, object: nil)
        hotlineIcon.isUserInteractionEnabled = true
        hotlineIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MainViewController.callDieuVan(_:))))
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func callDieuVan(_ gesture : UITapGestureRecognizer) {
//        let callDVVC = CallDieuVanViewController(nibName: "CallDieuVanViewController", bundle: nil)
//        let stpopup = STPopupController(rootViewController: callDVVC)
//        stpopup.present(in: self)
        let phone = "0916661523"
        guard let number = URL(string: "telprompt://" + phone) else { return }
        UIApplication.shared.openURL(number)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnMenuTouchUpInSide(_ sender: Any) {
        if (MainViewController.sharedInstance.slideMenu?.slideMenuController()?.isLeftOpen())! {
            MainViewController.sharedInstance.slideMenu?.slideMenuController()?.closeLeft()
        } else {
            MainViewController.sharedInstance.slideMenu?.slideMenuController()?.openLeft()
        }
    }
    
    func takePicture(notify : Notification) {
        
        let dict = notify.object as! NSDictionary
        
        let num = dict.value(forKey: "numberPic")
        let k = Int(num as! String)
        
        let date = dict.value(forKey: "Date")
        var dateTxt = ""
        if date != nil {
            dateTxt = date as! String
        }
        
        let shop = dict.value(forKey: "Shop")
        var shopName = ""
        if shop != nil {
            shopName = shop as! String
        }
        
        let nv = dict.value(forKey: "NhanVien")
        var nvName = ""
        if nv != nil {
            nvName = nv as! String
        }
        
        let takePicVC = TakePictureViewController(nibName: "TakePictureViewController", bundle: nil)
        takePicVC.dateTxt = dateTxt
        takePicVC.numberPic = k
        let tmp = shopName.folding(options: .diacriticInsensitive, locale: .current).replacingOccurrences(of: " ", with: "")
        NSLog("\(tmp)")
        takePicVC.shopName = tmp
        takePicVC.nvName = nvName.folding(options: .diacriticInsensitive, locale: .current).replacingOccurrences(of: " ", with: "")
        
        self.present(takePicVC, animated: true, completion: nil)
    }
}
