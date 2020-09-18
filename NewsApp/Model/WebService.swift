//
//  WebService.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/18/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

class WebService {
  static var session: SessionData = SessionData()
  static var isErrorLimit: Bool = false

  static func loadNews(isNextPage: Bool?, result: @escaping (Bool?, NSError?) -> Void){
    if isNextPage == true, isErrorLimit == false {
      session.currentPage += 1
    } else if isNextPage == true, isErrorLimit == true {
      return
    }
    ApiManager.shared.getNews(
      from: session.from,
      currentPage: session.currentPage,
      success: {
        result(true, nil)
      }, failed: { error in
        if error.code == 426 {
          isErrorLimit = true
        }
        result(nil, error)
      })
  }
}
