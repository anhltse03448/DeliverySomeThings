//
//  NhanVien.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 2/11/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import SwiftyJSON

class NhanVien: NSObject {
//    "id_nhan_vien":"132",
//    "ho_ten":"Nguyễn Văn Thái",
//    "img_path":"http://www.giaohangongvang.com/anh_nguoi_mau/132.jpg",
//    "quan":"Thanh Xuân",
//    "thanh_pho":"Hà Nội"
    var id_nhan_vien : String
    var ho_ten : String
    var img_path : String
    var quan : String
    var thanh_pho : String
    init(json : JSON) {
        self.id_nhan_vien = json["id_nhan_vien"].stringValue
        self.ho_ten = json["ho_ten"].stringValue
        self.img_path = json["img_path"].stringValue
        self.quan = json["quan"].stringValue
        self.thanh_pho = json["thanh_pho"].stringValue
    }
}
