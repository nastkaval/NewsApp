//
//  Constants.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/17/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

struct Constants {
  // MARK: - Date Formatters
  struct DateFormatters {
    static let dayDateFormatter: DateFormatter = {
      var dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      return dateFormatter
    }()

    static let timeDateFormatter: DateFormatter = {
      var dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm"
      return dateFormatter
    }()

    static let serverDateFormatter: DateFormatter = {
      var dateFormatter = DateFormatter()
      dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "")
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      return dateFormatter
    }()
  }
}
