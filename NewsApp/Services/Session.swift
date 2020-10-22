//
//  SessionService.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/17/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

enum DayDateFormattersConverter {
  static let dayDateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
  }()

  static let dayTimeDateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy (HH:mm)"
    return dateFormatter
  }()
}

class SessionData {
  var page = 1
  var from: String {
    return DayDateFormattersConverter.dayDateFormatter.string(from: Date())
  }
}
