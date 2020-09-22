//
//  SessionService.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/17/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

struct DayDateFormattersConverter {
  static let dayDateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
  }()
}

class SessionData {
  private var date: Date = Date()
  var nextPage: Int = 1
  var currentPage: Int = 1
  var pageSize: String = "15"
  var from: String {
    return DayDateFormattersConverter.dayDateFormatter.string(from: date)
  }
}
