//
//  Session.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/17/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

class Session {
  static var date = Date()
  static var currentPage: Int = 1
  static var nextPage: Int = 1
  static var from: String {
    return Constants.DateFormatters.dayDateFormatter.string(from: date)
  }
}
