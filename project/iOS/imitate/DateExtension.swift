//
//  DateExtension.swift
//  imitate
//
//  Created by garigari0118 on 2026/01/18.
//

import Foundation

extension Date {

    enum DateFormatStyle: String {
       case yyyy_MM_dd = "yyyy-MM-dd"
    }
    
    func toString(style: DateFormatStyle) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = style.rawValue
        return formatter.string(from: self)
    }
}
