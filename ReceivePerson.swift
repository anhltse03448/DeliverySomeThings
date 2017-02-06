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
    init(id_khach_hang : String , id_nguoi_gui : String , ten_nguoi_gui : String , sdt_nguoi_gui : String,
         id_tp_gui : String , id_quan_gui : String , id_don_hang : String , dia_chi_nhan : String,
         sdt_nguoi_nhan : String , nguoi_gui_tt : String , cod : String) {
        self.id_khach_hang = id_khach_hang
        self.id_nguoi_gui = id_nguoi_gui
        self.ten_nguoi_gui = ten_nguoi_gui
        self.sdt_nguoi_gui = sdt_nguoi_gui
        self.id_thanh_pho_gui = id_tp_gui
        self.id_quan_gui = id_quan_gui
        self.id_don_hang = id_don_hang
        self.dia_chi_nhan = dia_chi_nhan
        self.sdt_nguoi_nhan = sdt_nguoi_nhan
        self.nguoi_gui_thanh_toan = nguoi_gui_tt
        self.cod = cod
    }
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
    }
//    "id_khach_hang":3,
//    "id_nguoi_gui":null,
//    "ten_nguoi_gui":null,
//    "dia_chi_nguoi_gui":null,
//    "sdt_nguoi_gui":null,
//    "id_thanh_pho_gui":null,
//    "id_quan_gui":null,
//    "id_don_hang":12,
//    "dia_chi_nhan":null,
//    "sdt_nguoi_nhan":"0987654324",
//    "nguoi_gui_thanh_toan":null,
//    "cod":"222100"
}
