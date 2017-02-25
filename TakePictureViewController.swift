//
//  TakePictureViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/28/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class TakePictureViewController: BaseViewController {
    @IBOutlet weak var previewView : UIView!
    @IBOutlet weak var lblNumber : UILabel!
    @IBOutlet weak var imgRemove : UIButton!
    var dateTxt : String = ""
    var shopName : String = ""
    var numberPic : Int?
    var captureSession = AVCaptureSession();
    var sessionOutput = AVCaptureStillImageOutput();
    var previewLayer = AVCaptureVideoPreviewLayer();
    var count : Int = 0
    var nvName : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNumber.text = "0 / \(numberPic ?? 0)"
        count = 0
        setupSession()
//        let deviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInDuoCamera, AVCaptureDeviceType.builtInTelephotoCamera,AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.unspecified)
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
        
        for device in devices {
            if(device.position == AVCaptureDevicePosition.back){
                do{
                    
                    let input = try AVCaptureDeviceInput(device: device)
                    if(captureSession.canAddInput(input)){
                        captureSession.addInput(input);
                        
                        if(captureSession.canAddOutput(sessionOutput)){
                            captureSession.addOutput(sessionOutput);
                            captureSession.startRunning()
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait;
                            previewView.layer.addSublayer(previewLayer);
                            previewLayer.position = CGPoint.init(x: self.previewView.frame.width / 2 , y: self.previewView.frame.height / 2)
                        }
                    }
                }
                catch{
                    print("exception!");
                }
            }
        }
    }
    
    @IBAction func btnTakePicturePress(_ sender : UIButton) {
        takePicture()
    }
    @IBAction func btnEnd(_ sender : UIButton) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataPath = documentsDirectory.appendingPathComponent("GHOV/\(self.dateTxt)")
        let count1 = try? FileManager.default.contentsOfDirectory(atPath: "\(dataPath.path)").count
        if count1 == 0 || count1 == nil {
            try? FileManager.default.removeItem(at: dataPath)
        }        
        self.dismiss(animated: true) { 
            
        }
    }
    
    func takePicture() {
        count = count + 1
        lblNumber.text = "\(count) / \(numberPic ?? 0)"
        if let videoConnection = sessionOutput.connection(withMediaType: AVMediaTypeVideo) {
            
            sessionOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer) {
                    
                    if let cameraImage = UIImage(data: imageData) {
                        if let data = UIImageJPEGRepresentation(cameraImage, 1) {
                            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                            let dataPath = documentsDirectory.appendingPathComponent("GHOV/\(self.dateTxt)@\(self.shopName)@\(self.nvName)")
                            do {
                                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
                                let filename = dataPath.appendingPathComponent("\(self.count).png")
                                try? data.write(to: filename)
                                
                                let email = (UserDefaults.standard.value(forKey: "Username") as! String)
                                let dateFormat = DateFormatter()
                                dateFormat.dateFormat = "yyMMdd"
                                let name_folder = "\(self.dateTxt)_\(self.nvName)_\(self.shopName)_\(self.numberPic!)".toBase64()
                                let date = dateFormat.string(from: Date()).toBase64()
                                let soluongdon = "\(self.numberPic!)".toBase64()
                                let shop = self.shopName.toBase64()
                                let nhanvien = self.nvName.toBase64()
                                let name_file = "\(self.count).jpeg".toBase64()
                                
                                let param : [String : String] = ["session_id" : self.getSession(),
                                                                 "email": email.toBase64(),
                                                                 "date" : date,
                                                                 "soluongdon" : soluongdon,
                                                                 "shop" : shop,
                                                                 "nhanvien" : nhanvien,
                                                                 "name_file" : name_file,
                                                                 "name_folder" : name_folder,
                                                                 ]
                                //let url = Bundle.main.url(forResource: "2", withExtension: "jpg")
                                Alamofire.upload(multipartFormData: { multipartFormData in
                                    for (key, value) in param {
                                        multipartFormData.append((value.data(using: .utf8))!, withName: key)
                                    }
                                    multipartFormData.append(filename, withName: "uploaded_file")
                                }, to: "http://www.giaohangongvang.com/files/upload",
                                        encodingCompletion: { encodingResult in
                                            switch encodingResult {
                                            case .success(let upload, _, _):
                                                upload.responseString(completionHandler: { (response) in
                                                    let res = response.value ?? ""
                                                    switch res {
                                                        case "login_fail":
                                                            Alamofire.request("http://www.giaohangongvang.com/files/upload", method: .post, parameters: param).responseJSON(completionHandler: { (response) in
                                                                let data = JSON.init(data: response.data!)
                                                                NSLog("Anh ne: \(data)")
                                                                let status = data["status"].stringValue
                                                                if status == "fail" {
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
                                                            })
                                                        case "success":
                                                            try? FileManager.default.removeItem(at: filename)
                                                            break
                                                    default:
                                                            break
                                                    }
                                                })
                                                
                                            case .failure(let encodingError):
                                                print("error:\(encodingError)")
                                            }
                                })
                                /*
                                Alamofire.request("http://www.giaohangongvang.com/files/upload", method: .post, parameters: param).responseJSON(completionHandler: { (response) in
                                    let data = JSON.init(data: response.data!)
                                    NSLog("Anh ne: \(data)")
                                    let status = data["status"].stringValue
                                    if status == "fail" {
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
                                })
                                 */
                            } catch let error as NSError {
                                print("Error creating directory: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            })
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = previewView.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func setupSession() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension TakePictureViewController : AVCapturePhotoCaptureDelegate {
}
