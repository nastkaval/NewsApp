//
//  NewsController.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/18/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

struct TimeDateFormatters {
static let hoursMinutesDateFormatter: DateFormatter = {
      var dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm"
      return dateFormatter
    }()
}

class NewsController {
  static func loadNews(isNextPage: Bool?, completion: ( (Bool) -> ())?) {
    WebService.loadNews(isNextPage: isNextPage) { (success, error) in
      if success != nil {
        completion?(true)
      }
      if error != nil {
        completion?(false)
      }
    }
  }
}
