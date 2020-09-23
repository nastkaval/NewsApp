//
//  NewsModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/18/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol WebServiceDelegate: class {
  func callApi(isNextPage: Bool)
}

protocol DatabaseServiceDelegate: class {
  func loadData()
  func filterData(keyWord: String)
}

protocol NewsModelDelegate: class {
  func dataDidUpdateSuccess()
  func dataDidUpdateWithError(_ errorMessage: String)
}

class NewsModel {
  var session = SessionData()
  var isErrorLimit: Bool = false
  private var listNews: [NewsEntity] = []
  public weak var newsModelDelegate: NewsModelDelegate?

  func object(_ index: Int) -> NewsEntity {
    return listNews[index]
  }

  func count() -> Int {
    return listNews.count
  }
}

extension NewsModel: WebServiceDelegate {
  func callApi(isNextPage: Bool) {
    if isNextPage == true, isErrorLimit == false {
      session.currentPage += 1
    } else if isNextPage == true, isErrorLimit == true {
      return
    }
    ApiManager.shared.getNews(
      from: session.from,
      currentPage: session.currentPage,
      pageSize: session.pageSize,
      success: { [weak self] result in
        switch isNextPage {
        case true:
          break
        case false:
          DatabaseManager.shared.removeAllData()
        }
        DatabaseManager.shared.saveData(newsEntities: result)
        self?.loadData()
      }, failed: { [weak self] error in
        switch error {
        case .limitNewsError:
          self?.isErrorLimit = true
        case .serverError:
          break
        }
        self?.newsModelDelegate?.dataDidUpdateWithError(error.description)
        self?.newsModelDelegate?.dataDidUpdateWithError(error.description)
      })
  }
}

extension NewsModel: DatabaseServiceDelegate {
  func loadData() {
    listNews = DatabaseManager.shared.loadData()
    self.newsModelDelegate?.dataDidUpdateSuccess()
  }

  func filterData(keyWord: String) {
    listNews = DatabaseManager.shared.loadFilterData(predicate: keyWord)
    self.newsModelDelegate?.dataDidUpdateSuccess()
  }
}
