//
//  Date+Format.swift
//  serverPackageDescription
//
//  Created by Danny on 15/01/2018.
//

import Foundation

extension Date {
  var mysqlString: String {
    return DateFormatter.mysql.string(from: self)
  }
}
