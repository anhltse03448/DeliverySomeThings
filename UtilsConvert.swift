//
//  UtilsConvert.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/23/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

enum KeyDefault {
    case session
    case ho_ten
    case id_tp
    case id_quan
    case id_phuong
    case lat
    case long
}


class UtilsConvert: NSObject {
    static func convertKeyDefault(keyDefault : KeyDefault)  -> String {
        switch keyDefault  {
        case KeyDefault.session:
            return "session"
        case KeyDefault.ho_ten:
            return "ho_ten"
        case KeyDefault.id_phuong:
            return "id_phuong"
        case KeyDefault.id_tp:
            return "id_tp"
        case KeyDefault.id_quan:
            return "id_quan"
        case KeyDefault.lat:
            return "lat"
        case KeyDefault.long:
            return "long"
        default:
            return ""
        }
    }
    static func convertMoney(str : Int) ->String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        var price = currencyFormatter.string(from: 123456)
        NSLog("\(price)")
        return price!
    }
    static var dateSendLocation = Date()
}
struct Number {
    static let formatterWithSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Integer {
    var stringFormattedWithSeparator: String {
        return Number.formatterWithSeparator.string(from: self as! NSNumber) ?? ""
    }
}
extension String {
    var stringFormattedWithSeprator : String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        var aaa = self
        if self == "" {
            aaa = "0"
        }
        
        let str = formatter.number(from: aaa)
        return Number.formatterWithSeparator.string(from: str!)!
    }
}
