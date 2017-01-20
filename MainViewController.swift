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
        self.slideMenu = slideMenu
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnMenuTouchUpInSide(_ sender: Any) {
        if (self.slideMenu?.slideMenuController()?.isLeftOpen())! {
            self.slideMenu?.slideMenuController()?.closeLeft()
        } else {
            self.slideMenu?.slideMenuController()?.openLeft()
        }
    }    
}
