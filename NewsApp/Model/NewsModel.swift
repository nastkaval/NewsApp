//
//  NewsModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/18/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol NewsModelDelegate: class {
  func dataDidUpdateSuccess()
  func dataDidUpdateWithError(_ errorMessage: String)
}

class NewsModel {
  var session = SessionData()
  var isErrorLimit: Bool = false
  private var listNews: [NewsEntity] = []
  public weak var newsModelDelegate: NewsModelDelegate?
}

extension NewsModel {
  func object(_ index: Int) -> NewsEntity {
    return listNews[index]
  }

  func count() -> Int {
    return listNews.count
  }
}

extension NewsModel: ApiProvider, DatabaseProvider {
  func getData(isNextPage: Bool) {
    callApi(session: session) { [weak self] (newsArray, error) in
      if let newsArray = newsArray {
        switch isNextPage {
        case true:
          break
        case false:
          self?.removeData()
        }
        self?.saveData(newsEntities: newsArray)
        self?.loadNews()
      }
      if let error = error {
        switch error {
        case .limitNewsError:
          self?.isErrorLimit = true
        case .serverError, .parseError:
          break
        }
        self?.failedGetData(errorMessage: error.description)
      }
    }
  }
  
  func successGetData() {
    newsModelDelegate?.dataDidUpdateSuccess()
  }

  func failedGetData(errorMessage: String) {
    newsModelDelegate?.dataDidUpdateWithError(errorMessage)
  }

  func getFilterNews(keyWord: String) {
    listNews = filterData(keyWord: keyWord)
    newsModelDelegate?.dataDidUpdateSuccess()
  }

  func loadNews() {
    listNews = loadData()
    newsModelDelegate?.dataDidUpdateSuccess()
  }
}
