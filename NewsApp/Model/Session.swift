//
//  SessionService.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/17/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

enum DayDateFormattersConverter { //https://realm.github.io/SwiftLint/convenience_type.html
  static let dayDateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
  }()
}

class SessionData {
  private var date = Date()
  var page: Int = 1
  let pageSize: Int = 15
  var from: String {
    return DayDateFormattersConverter.dayDateFormatter.string(from: date)
  }
}
