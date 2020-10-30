//
//  DetailsModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol DetailsModelOutput: AnyObject {
  func dataLoadSuccess()
  func dataLoadWithError(_ errorMessage: String)
}

final class DetailsModel {
  private var news: News
  private let databaseManager: DatabaseProtocol
  weak var output: DetailsModelOutput?

  init(loadService: DatabaseProtocol, news: News) {
    self.news = news
    self.databaseManager = loadService
  }
}

extension DetailsModel {
  func object() -> News {
    return news
  }

  func checkIsExistObjectInDatabase() {
    let lookingObject = databaseManager.checkObjectIsExistBy(id: news.urlNewsStr)
    guard lookingObject != nil else {
      saveNewsToDatabase()
      return
    }
    news.isSaved = true
    output?.dataLoadSuccess()
  }

  private func saveNewsToDatabase() {
    let newsEntity = NewsEntity(
      author: news.author,
      title: news.title,
      descriptionText: news.descriptionText,
      urlNewsStr: news.urlNewsStr,
      urlToImageStr: news.urlToImageStr,
      publishedAtStr: news.publishedAtStr,
      content: news.content)
    if databaseManager.saveData(newsEntity: newsEntity) {
      checkIsExistObjectInDatabase()
    }
  }
}
