//
//  MainViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/19/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class MainViewController: UIViewController {
    @IBOutlet weak var btnMenu : UIButton!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var lblTitle : UILabel!
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        NSLog("\(notify.object)") 
        let takePicVC = TakePictureViewController(nibName: "TakePictureViewController", bundle: nil)
        self.present(takePicVC, animated: true, completion: nil)
    }
}
