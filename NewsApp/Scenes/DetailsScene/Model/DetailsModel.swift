//
//  DetailsModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

final class DetailsModel {
  private var news: News
  private let databaseManager: DatabaseProtocol
  weak var delegate: DetailsDataSourceDelegate?

  init(loadService: DatabaseProtocol, news: News) {
    self.news = news
    self.databaseManager = loadService
  }

  private func saveData() {
    let newsEntity = NewsEntity(
      author: news.author,
      title: news.title,
      descriptionText: news.descriptionText,
      urlNewsStr: news.urlNewsStr,
      urlToImageStr: news.urlToImageStr,
      publishedAtStr: news.publishedAtStr,
      content: news.content)
    if databaseManager.save(data: newsEntity) {
      checkData()
    }
  }
}

// MARK: - DetailsDataSource
extension DetailsModel: DetailsDataSource {
  var item: News {
    return news
  }

  func checkData() {
    let id = news.urlNewsStr
    guard databaseManager.checkObject(by: id) else {
      saveData()
      return
    }
    news.isSaved = true
    delegate?.dataLoadSuccess()
  }
}
