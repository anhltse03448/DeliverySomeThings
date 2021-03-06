//
//  GhiChuViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/25/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire
import SwiftyJSON
import STPopup

class GhiChuViewController: BaseViewController {
    @IBOutlet weak var txtghichu : UITextView!
    var dov : DeliveryObject?
    static let sharedInstance = GhiChuViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
     //   self.popupController?.navigationBar.isHidden = true
         self.popupController?.navigationBarHidden = true
        self.contentSizeInPopup  = CGSize(width: 300, height: 300)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ghichuTouchUp(_ sender : UIButton){
        DeliveryViewController.shouldLoad = true
        let id_don_hang = dov?.id_don_hang
        let ghichu = txtghichu.text ?? ""
        if ghichu == "" {
            self.view.makeToast("Không có ghi chú", duration: 1.0, position: .center)
            return
        }
        if ghichu != "" {
            let param : [String : String] = ["session" : self.getSession(),
                                             "id_don_hang" : (id_don_hang?.toBase64())!,
                                             "ghi_chu" : ghichu.toBase64()]
            Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/ghichu", method: .post, parameters: param).response(completionHandler: { (response) in
                DeliveryViewController.shouldLoad = true
                let data = JSON.init(data: response.data!)                
                let warning = data["warning"].stringValue
                DeliveryViewController.sharedInstance.view.makeToast(warning, duration: 2.0, position: .center)
                self.popupController?.dismiss()
            })
        }
    }
    
    @IBAction func closeTouchUp(_ sender : UIButton) {
        DeliveryViewController.shouldLoad = false
        self.popupController?.dismiss(completion: { 
            ReceiveViewController.shouldLoad = false
        })
    }
    @IBAction func lydoTouchUp(_ sender : UIButton){
        let tag = sender.tag
        var str = ""
        switch tag {
            case 0:
                str = "Không liên lạc được người nhận"
            let controller = MFMessageComposeViewController()
            controller.body = "Chao a/c. Em ben GiaoHangOngVang.vn. A/c co hang tu \(dov?.ten_nguoi_gui ?? ""). Em da lien lac voi a/c nhung khong duoc. Luc nao co thoi gian a/c ll lai voi em. Em cam on"
            controller.recipients = [(dov?.sdt_nguoi_nhan)!]
            controller.messageComposeDelegate = self
            DeliveryViewController.shouldLoad = false
            //self.popupController?.dismiss()
            self.present(controller, animated: true, completion: nil)
                
            //self.popupController?.dismiss()
            case 1:
                str = "Hẹn giờ"
                //self.popupController?.dismiss()
                DeliveryViewController.sharedInstance.ghiChuVC?.dismiss(animated: true, completion: { 
                    let hengioVC = HenGioViewController(nibName: "HenGioViewController", bundle: nil)
                    hengioVC.dov = self.dov
                    let stpopup = STPopupController(rootViewController: hengioVC)
                    stpopup.present(in: DeliveryViewController.sharedInstance)
                })
            
                //
            case 2:
                str = "Đơn hàng sai số điện thoại người nhận"
            case 3:
                str = "Phụ cước"
                if self.dov?.hang_lien_tinh == "" {
                    DeliveryViewController.sharedInstance.ghiChuVC?.dismiss(animated: true, completion: {
                        let hengioVC = PhuCuocNoiTinhViewController(nibName: "PhuCuocNoiTinhViewController", bundle: nil)
                        hengioVC.dov = self.dov
                        let stpopup = STPopupController(rootViewController: hengioVC)
                        stpopup.present(in: DeliveryViewController.sharedInstance)
                    })
                } else {
                    DeliveryViewController.sharedInstance.ghiChuVC?.dismiss(animated: true, completion: {
                        let hengioVC = PhuCuocViewController(nibName: "PhuCuocViewController", bundle: nil)
                        hengioVC.dov = self.dov
                        let stpopup = STPopupController(rootViewController: hengioVC)
                        stpopup.present(in: DeliveryViewController.sharedInstance)
                    })
                }
            
            case 4:
                //str = "Gọi shop"
                let phone = dov?.sdt_nguoi_gui
                guard let number = URL(string: "telprompt://" + phone!) else {
                    self.view.makeToast("Ko có sdt", duration: 1.0, position: .center)
                    return }
            UIApplication.shared.openURL(number)
                //UIApplication.shared.open(number, options: [:], completionHandler: nil)
            default:
            DeliveryViewController.shouldLoad = false
            self.popupController?.dismiss()
            
            let doiDC = DoiDiaChiViewController(nibName: "DoiDiaChiViewController", bundle: nil)
            doiDC.dov = self.dov
            let stpopup = STPopupController(rootViewController: doiDC)
            stpopup.present(in: DeliveryViewController.sharedInstance)
        }
        txtghichu.text = str
    }
}
extension GhiChuViewController : MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true) { 
            
        }
        
    }
}
