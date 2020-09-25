//
//  NewsModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/18/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol NewsModelOutput: class {
  func dataLoadSuccess()
  func dataLoadWithError(_ errorMessage: String)
}

protocol NewsModelInput: class {
}

final class NewsModel {
  private var session = SessionData()
  private var listNews: [NewsEntity] = []
  public weak var output: NewsModelOutput?
  private let apiManager: ApiManagerProtocol
  private let databaseManager: DatabaseProtocol

  init(apiManager: ApiManagerProtocol, databaseManager: DatabaseProtocol) {
    self.apiManager = apiManager
    self.databaseManager = databaseManager
  }

  func getData(isNextPage: Bool) {
    if isNextPage {
      session.page += 1
    } else {
      session.page = 1
    }
    apiManager.callApi(session: session) { [weak self] result in
      switch result {
      case .success(let newsArray):
        self?.successGetData(newsEntities: newsArray)
      case .failure(let error):
        self?.failedGetData(errorMessage: error.description)
      }
    }
  }

  func getFilterNews(keyWord: String) {
    if !keyWord.isEmpty, keyWord.count > 2 {
      databaseManager.filterData(keyWord: keyWord) { [weak self] result in
        switch result {
        case .success(let newsArray):
          self?.successGetData(newsEntities: newsArray)
        case .failure(let error):
          self?.failedGetData(errorMessage: error.description)
        }
      }
    } else if keyWord.isEmpty {
      databaseManager.loadData { [weak self] result in
        switch result {
        case .success(let newsArray):
          self?.listNews = newsArray
        case .failure(let error):
          self?.failedGetData(errorMessage: error.description)
        }
      }
    }
  }
}

extension NewsModel {
  private func successGetData(newsEntities: [NewsEntity]) {
    databaseManager.saveData(newsEntities: newsEntities) { [weak self] result in
      switch result {
      case .success:
        break
      case .failure(let error):
        self?.failedGetData(errorMessage: error.description)
      }
    }
    databaseManager.loadData { [weak self] result in
      switch result {
      case .success(let newsArray):
        self?.listNews = newsArray
      case .failure(let error):
        self?.failedGetData(errorMessage: error.description)
      }
    }
    output?.dataLoadSuccess()
  }

  private func failedGetData(errorMessage: String) {
    output?.dataLoadWithError(errorMessage)
  }
}

extension NewsModel {
  func object(_ index: Int) -> NewsEntity {
//    if index <= listNews.endIndex { }
  return listNews[index]
  }

  func count() -> Int {
  return listNews.count
  }
}
