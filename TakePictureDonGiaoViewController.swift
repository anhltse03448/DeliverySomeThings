//
//  TakePictureDonGiaoViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 3/4/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import Alamofire

class TakePictureDonGiaoViewController: BaseViewController {
    @IBOutlet weak var previewView : UIView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblDiaChi : UILabel!
    var titleStr : String = ""
    var idDonHang : String = ""
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
        lblTitle.text = titleStr
        count = 0
        setupSession()
        //        let deviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInDuoCamera, AVCaptureDeviceType.builtInTelephotoCamera,AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.unspecified)
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
        
        for device in devices {
            if(device.position == AVCaptureDevicePosition.back){
                do{
                    if(device.isFocusModeSupported(.continuousAutoFocus)) {
                        try! device.lockForConfiguration()
                        device.focusMode = .continuousAutoFocus
                        device.unlockForConfiguration()
                    }
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
    
    func takePicture() {
        if let videoConnection = sessionOutput.connection(withMediaType: AVMediaTypeVideo) {
            
            sessionOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer) {
                    
                    if let cameraImage = UIImage(data: imageData) {
                        if let data = UIImageJPEGRepresentation(cameraImage, 1) {
                            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                            let dataPath = documentsDirectory.appendingPathComponent("GHOV_TMP/\(self.idDonHang)")
                            do {
                                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
                                let filename = dataPath.appendingPathComponent("\(self.idDonHang).png")
                                try? data.write(to: filename)
                                
                                let param : [String : String] = ["session" : self.getSession(),
                                                                 "id_donhang" : self.idDonHang.toBase64()]
                                self.dismiss(animated: true, completion: nil)
                                Alamofire.upload(multipartFormData: { multipartFormData in
                                    for (key, value) in param {
                                        multipartFormData.append((value.data(using: .utf8))!, withName: key)
                                    }
                                    multipartFormData.append(filename, withName: "uploaded_file")
                                }, to: "http://www.giaohangongvang.com/api/files/upload-dongiao",
                                   encodingCompletion: { encodingResult in
                                    switch encodingResult {
                                    case .success(let upload, _, _):
                                        upload.responseString(completionHandler: { (response) in
                                            let res = response.value ?? ""
                                            switch res {
                                            case "login_fail":
                                                break
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
