//
//  Purchase.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/18/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class Purchase: NSObject {
//    "id_don_hang" : 20787,
//    "sdt_nguoi_nhan" : "0903865194",
//    "dia_chi_nguoi_nhan" : "51 xuân diệu, quận tây hồ, hà nội, Tây Hồ, Hà Nội",
//    "nguoi_nhan_thanh_toan" : "123,456",
//    "ten_nguoi_gui" : "Vibest",
//    "ghi_chu" : "test 2\\nNgười nhận thanh toán cước :123,456 vnđ",
//    "cod" : "549000",
//    "ngay_hoan_thanh" : "2017-02-17",
//    "ten_nguoi_nhan" : "trần thị thanh hoa ( gọi trước khi đến)",
//    "tinh_trang_don_hang" : 8,
//    "sdt_nguoi_gui" : "01676955989"
    var id_don_hang : String
    var sdt_nguoi_nhan : String
    var dia_chi_nguoi_nhan : String
    var nguoi_nhan_thanh_toan : String
    var ten_nguoi_gui : String
    var ghi_chu : String
    var cod : String
    var ngay_hoan_thanh : String
    var ten_nguoi_nhan : String
    var tinh_trang_don_hang : String
    var sdt_nguoi_gui : String
    
    init(json : JSON) {
        self.id_don_hang = json["id_don_hang"].stringValue
        self.sdt_nguoi_nhan = json["sdt_nguoi_nhan"].stringValue
        self.dia_chi_nguoi_nhan = json["dia_chi_nguoi_nhan"].stringValue
        self.nguoi_nhan_thanh_toan = json["nguoi_nhan_thanh_toan"].stringValue
        self.ten_nguoi_gui = json["ten_nguoi_gui"].stringValue
        self.ghi_chu = json["ghi_chu"].stringValue
        self.cod = json["cod"].stringValue
        self.ngay_hoan_thanh = json["ngay_hoan_thanh"].stringValue
        self.ten_nguoi_nhan = json["ten_nguoi_nhan"].stringValue
        self.tinh_trang_don_hang = json["tinh_trang_don_hang"].stringValue
        self.sdt_nguoi_gui = json["sdt_nguoi_gui"].stringValue
    }
}
