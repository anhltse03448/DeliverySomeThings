//
//  DeliveryObject.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/25/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class DeliveryObject: NSObject {
    var id_don_hang : String
    var ten_nguoi_gui : String
    var sdt_nguoi_gui : String
    var ten_nguoi_nhan : String
    var dia_chi_nguoi_nhan : String
    var sdt_nguoi_nhan : String
    var ngay_hen_giao : String
    var gio_hen_bat_dau: String
    var gio_hen_ket_thuc: String
    var ghi_chu: String
    var lat : Double
    var lon : Double
    var cod: String
    var id_thanhpho_gui : String
    init(json : JSON) {
        self.id_don_hang = json["id_don_hang"].stringValue
        self.ten_nguoi_gui = json["ten_nguoi_gui"].stringValue
        self.sdt_nguoi_gui = json["sdt_nguoi_gui"].stringValue
        self.ten_nguoi_nhan = json["ten_nguoi_nhan"].stringValue
        self.dia_chi_nguoi_nhan = json["dia_chi_nguoi_nhan"].stringValue
        self.sdt_nguoi_nhan = json["sdt_nguoi_nhan"].stringValue
        self.ngay_hen_giao = json["ngay_hen_giao"].stringValue
        self.gio_hen_bat_dau = json["gio_hen_bat_dau"].stringValue
        self.gio_hen_ket_thuc = json["gio_hen_ket_thuc"].stringValue
        self.ghi_chu = json["ghi_chu"].stringValue
        self.lat = json["lat"].doubleValue
        self.lon = json["lon"].doubleValue
        self.cod = json["cod"].stringValue
        self.id_thanhpho_gui = json["id_thanhpho_gui"].stringValue
    }        
}
