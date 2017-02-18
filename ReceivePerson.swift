//
//  ReceivePerson.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/23/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReceivePerson: NSObject {
    var id_khach_hang : String
    var id_nguoi_gui : String
    var ten_nguoi_gui : String
    var sdt_nguoi_gui : String
    var id_thanh_pho_gui : String
    var id_quan_gui : String
    var id_don_hang : String
    var dia_chi_nhan : String
    var sdt_nguoi_nhan : String
    var nguoi_gui_thanh_toan : String
    var cod : String
    var dia_chi_nguoi_gui : String
    
    
    init(json : JSON) {
        self.id_khach_hang = json["id_khach_hang"].stringValue
        self.id_nguoi_gui = json["id_nguoi_gui"].stringValue
        self.ten_nguoi_gui = json["ten_nguoi_gui"].stringValue
        self.sdt_nguoi_gui = json["sdt_nguoi_gui"].stringValue
        self.id_thanh_pho_gui = json["id_thanh_pho_gui"].stringValue
        self.id_quan_gui = json["id_quan_gui"].stringValue
        self.id_don_hang = json["id_don_hang"].stringValue
        self.dia_chi_nhan = json["dia_chi_nhan"].stringValue
        self.sdt_nguoi_nhan = json["sdt_nguoi_nhan"].stringValue
        self.nguoi_gui_thanh_toan = json["nguoi_gui_thanh_toan"].stringValue
        self.cod = json["cod"].stringValue
        self.dia_chi_nguoi_gui = json["dia_chi_nguoi_gui"].stringValue
    }
}
