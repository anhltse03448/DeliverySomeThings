//
//  RegisInforFamilyViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/22/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

class RegisInforFamilyViewController: UIViewController {
    @IBOutlet weak var imgBack : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisInforFamilyViewController.dismisBack(_:))))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismisBack(_ gesture : UITapGestureRecognizer) {
        self.navigationController?.dismiss(animated: true, completion: { 
            
        })
    }
}
