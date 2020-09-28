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

final class NewsModel {
  private var session = SessionData() //?
  private var listNews: [NewsEntity] = []
  public weak var output: NewsModelOutput?

  private let apiManager: ApiManagerProtocol
  private let databaseManager: DatabaseProtocol

  init(apiManager: ApiManagerProtocol, databaseManager: DatabaseProtocol) {
    self.apiManager = apiManager
    self.databaseManager = databaseManager
  }

  convenience init(dependency: ModelDependencyProtocol) {
    self.init(apiManager: dependency.apiManager, databaseManager: dependency.databaseManager)
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
        self?.saveDataToDatabase(data: newsArray)
      case .failure(let error):
        self?.output?.dataLoadWithError(error.description)
      }
    }
  }

  func getFilterNews(keyWord: String) {
    if !keyWord.isEmpty, keyWord.count > 2 {
      databaseManager.filterData(keyWord: keyWord) { result in
        switch result {
        case .success(let newsArray):
          self.listNews = newsArray
          self.output?.dataLoadSuccess()
        case .failure(let error):
          self.output?.dataLoadWithError(error.description)
        }
      }
    } else if keyWord.isEmpty {
      loadDataFromDatabase()
    }
  }

  private func saveDataToDatabase(data: [NewsEntity]) {
    databaseManager.saveData(newsEntities: data) { result in
      switch result {
      case .success:
        self.loadDataFromDatabase()
      case .failure(let error):
        self.output?.dataLoadWithError(error.description)
        }
    }
  }

  private func loadDataFromDatabase() {
    databaseManager.loadData { result in
      switch result {
      case .success(let newsArray):
        self.listNews = newsArray
        self.output?.dataLoadSuccess()
      case .failure(let error):
        self.output?.dataLoadWithError(error.description)
          }
    }
  }
}

extension NewsModel {
  func object(_ index: Int) -> NewsEntity {
    //    if index <= listNews.endIndex { } Q
    return listNews[index]
  }

  func count() -> Int {
    return listNews.count
  }
}

extension NewsEntity: ViewModel {
  var publishedAt: Date {
    return publishedAtDate
  }

  var imageUrl: URL? {
    if let url = URL(string: urlToImageStr) {
      return url
    } else {
      return nil
    }
  }
}

