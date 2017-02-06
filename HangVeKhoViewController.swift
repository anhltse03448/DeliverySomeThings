//
//  HangVeKhoViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/21/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import CarbonKit

class HangVeKhoViewController: UIViewController {
    static let sharedInstance = HangVeKhoViewController()
    var donHenGiaoVC : DonHenGiaoViewController?
    var donHoanVC : DonHoanViewController?
    @IBOutlet weak var contentView : UIView!
    var tabsName : [String] = ["ĐƠN HẸN GIAO","ĐƠN HOÀN"]
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
        initCarbonTabs()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViewController() {
        donHenGiaoVC = DonHenGiaoViewController(nibName: "DonHenGiaoViewController", bundle: nil)
        donHoanVC = DonHoanViewController(nibName: "DonHoanViewController", bundle: nil)
    }
    
    func initCarbonTabs() {
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: tabsName, delegate: self)
        
        carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: contentView)
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.setTabBarHeight(40)
        carbonTabSwipeNavigation.setIndicatorHeight(0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.backgroundColor = UIColor.init(rgba: "#FAFAFA")
        carbonTabSwipeNavigation.setNormalColor(UIColor(rgba: "#040D14"), font: UIFont.systemFont(ofSize: 13))
        carbonTabSwipeNavigation.setSelectedColor(UIColor(rgba: "#007D01"), font: UIFont.boldSystemFont(ofSize: 14))
        
        for i in 0..<tabsName.count {
            carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(UIScreen.main.bounds.width / 2, forSegmentAt: i)
        }
    }
}
extension HangVeKhoViewController : CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index {
        case 0:
            return donHenGiaoVC!
        default:
            return donHoanVC!
        }
    }
}
