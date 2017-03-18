//
//  QuetMaVachViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/28/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import AVFoundation
import ToastSwiftFramework
import Alamofire
import SwiftyJSON
import STPopup
class ObjectReceiScan : NSObject {
    /*
    "detail" : {
    "id_don_hang" : 20836,
    "sdt_nguoi_nhan" : "0961010388",
    "ten_nguoi_gui" : "Eropi",
    "ghi_chu" : "[Nhất-s] 1 USB8V_29 \\nkhách hàng hẹn sang  ngày 2017-02-23",
    "cod" : "290000",
    "ten_nguoi_nhan" : "anh Tuấn",
    "tinh_trang_don_hang" : 8,
    "sdt_nguoi_gui" : "0987426945"
    */
    var id_don_hang : String
    var sdt_nguoi_nhan : String
    var ten_nguoi_gui : String
    var ghi_chu : String
    var cod : String
    var ten_nguoi_nhan : String
    var tinh_trang_don_hang : String
    var sdt_nguoi_gui : String
    
    init(json : JSON) {
        self.id_don_hang = json["id_don_hang"].stringValue
        self.sdt_nguoi_nhan = json["sdt_nguoi_nhan"].stringValue
        self.ten_nguoi_gui = json["ten_nguoi_gui"].stringValue
        self.ghi_chu = json["ghi_chu"].stringValue
        self.cod = json["cod"].stringValue
        self.ten_nguoi_nhan = json["ten_nguoi_nhan"].stringValue
        self.tinh_trang_don_hang = json["tinh_trang_don_hang"].stringValue
        self.sdt_nguoi_gui = json["sdt_nguoi_gui"].stringValue
    }
}
class QuetMaVachViewController: BaseViewController {
    @IBOutlet weak var btnFlash : UIButton!
    @IBOutlet weak var viewSuccess : UIView!
    @IBOutlet weak var previewView : UIView!
    var popupView:ViewSuccess?
    @IBOutlet weak var lblID : UILabel!
    @IBOutlet weak var lblNguoiGui : UILabel!
    @IBOutlet weak var lblNguoiNhan : UILabel!
    @IBOutlet weak var lblPhone : UILabel!
    @IBOutlet weak var lblAddress : UILabel!
    @IBOutlet weak var lblThuHo : UILabel!
    @IBOutlet weak var lblGhiChu : UILabel!
    @IBOutlet weak var lblRes : UILabel!
    @IBOutlet weak var txtPhone : UITextField!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var objScan : ObjectReceiScan?
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode ]
    var endTime : Date?
    let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSuccess.alpha = 0
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        
        
        do {
            if(captureDevice?.isFocusModeSupported(.continuousAutoFocus))! {
                try! captureDevice?.lockForConfiguration()
                captureDevice?.focusMode = .continuousAutoFocus
                captureDevice?.unlockForConfiguration()
            }
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            captureSession?.sessionPreset = AVCaptureSessionPresetPhoto
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait;
            videoPreviewLayer?.position = CGPoint.init(x: (self.videoPreviewLayer?.frame.width)! / 2 , y: (self.videoPreviewLayer?.frame.height)! / 2)
            
            previewView.layer.addSublayer(videoPreviewLayer!);
            
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Move the message label and top bar to the front
//            view.bringSubview(toFront: messageLabel)
//            view.bringSubview(toFront: topbar)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showPopupView(){
        if objScan != nil {
            self.viewSuccess.alpha = 1
            self.lblGhiChu.text = "Đơn đã có người nhận giao \n Nhân viên nhận đơn sẽ chịu trách nhiệm về đơn hàng này"
            self.lblID.text = objScan?.id_don_hang
            self.lblNguoiGui.text = objScan?.ten_nguoi_gui
            self.lblNguoiNhan.text = objScan?.ten_nguoi_nhan
            self.lblPhone.text = objScan?.sdt_nguoi_gui
            self.lblAddress.text = "DC nguoi nhan"
            self.lblThuHo.text = objScan?.cod
            self.lblGhiChu.text = objScan?.ghi_chu
        }
    }
    
    @IBAction func btnCloseTouchUp(_sender : UIButton){
        self.viewSuccess.alpha = 0
    }
    
    @IBAction func receiveTouchUp(_sender : UIButton){
        let id = objScan?.id_don_hang ?? ""
        let param : [String : String] = ["session": self.getSession() , "list" : (id.toBase64()) ]
        NSLog("\(param)")
        Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/nhan-donhang-ton", method: .post, parameters: param).responseJSON { (response) in
            if response.data != nil {
                let json = JSON.init(data: response.data!)
                NSLog("\(json)")
                let warning = json["warning"].stringValue
                self.view.makeToast(warning, duration: 2.0, position: .center)
                self.objScan = nil
                self.viewSuccess.alpha = 0
            } else {
                
            }
        }
    }
    
    func hidePopupView(){
        self.viewSuccess.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.50, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            
//            self.grayBackgroundView.alpha = 0
            self.popupView!.alpha = 0
            
        }) { (value:Bool) -> Void in
            self.popupView!.removeFromSuperview()
  //          self.grayBackgroundView.removeFromSuperview()
            
        }
        
    }
    
    @IBAction func didChange(_sender : UITextField){
        let txt = txtPhone.text ?? ""
        if txt.characters.count == 8 {
            self.requestDataWithTrackID(id: txt)
            txtPhone.text = ""
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = previewView.bounds
    }
    
    func requestDataWithTrackID(id : String){
        self.showLoadingHUD()
        let param : [String : String] = ["session":self.getSession(),
                                         "tracking_id" : id.toBase64()]
        NSLog("\(param)")
        Alamofire.request("http://www.giaohangongvang.com/api/donhang/scan-barcode", method: .post, parameters: param).responseJSON(completionHandler: { (response) in
            self.hideLoadingHUD()
            let data = JSON.init(data: response.data!)
            NSLog("\(data)")
            let status = data["status"].stringValue
            if status == "fail" {
                let vc = ScanBarCodeFailViewController(nibName: "ScanBarCodeFailViewController", bundle: nil)
                vc.idDonHang = id
                let stpopup = STPopupController(rootViewController: vc)
                stpopup.present(in: self)
            } else {
                let detail = data["detail"]
                let obj = ObjectReceiScan(json: detail)
                self.objScan = obj
                self.showPopupView()
            }
        })
    }
    
    @IBAction func turnOffOnFlash(_sender : UIButton){
        do {
            try captureDevice?.lockForConfiguration()
            if captureDevice?.torchMode == AVCaptureTorchMode.on {
                captureDevice?.torchMode = .off
            } else {
                captureDevice?.torchMode = .on
            }
            captureDevice?.unlockForConfiguration()

        } catch {
            
        }
    }
}
extension QuetMaVachViewController : AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            //messageLabel.text = "No QR/barcode is detected"
            NSLog("No hihi")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                //NSLog("\(metadataObj.stringValue ?? "")")
                let value = metadataObj.stringValue ?? ""
                if endTime != nil {
                    if Date().seconds(from: endTime!) >= 2 {
                        self.requestDataWithTrackID(id: value)
                        endTime = Date()
                    }
                } else {
                    self.requestDataWithTrackID(id: value)
                    endTime = Date()
                }
            }
        }
    }
}
