//
//  DetailesModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/06/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol OfflineNewsModelOutput: class {
  func dataLoadSuccess(state: Bool)
}

final class OfflineNewsModel {
  weak var output: OfflineNewsModelOutput?
  private var listNews: [NewsViewModel] = []
  private let databaseManager: DatabaseProtocol

  private init(databaseManager: DatabaseProtocol) {
    self.databaseManager = databaseManager
  }

  convenience init(dependency: ModelDependencyProtocol) {
    self.init(databaseManager: dependency.databaseManager)
  }

  func loadDataFromDatabase() {
    let dataArray = databaseManager.loadData()
    if !dataArray.isEmpty {
      self.listNews = dataArray.map { item -> NewsViewModel in
        NewsViewModel(author: item.author, title: item.title, descriptionNews: item.descriptionNews, content: item.content, urlNewsStr: item.urlNewsStr, urlToImageStr: item.urlToImageStr, publishedAtStr: item.publishedAtStr)
      }
      output?.dataLoadSuccess(state: true)
    } else {
      output?.dataLoadSuccess(state: false)
    }
  }
}

extension OfflineNewsModel {
  func object(_ index: Int) -> NewsViewModel {
    return listNews[index]
  }

  func count() -> Int {
    return listNews.endIndex
  }
}
