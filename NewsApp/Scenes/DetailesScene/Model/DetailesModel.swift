//
//  DetailesModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol DetailesModelOutput: AnyObject {
  func dataLoadSuccess()
  func dataLoadWithError(_ errorMessage: String)
}

final class DetailesModel {
  private var news: NewsViewModel
  private let databaseManager: DatabaseProtocol
  weak var output: DetailesModelOutput?

  init(loadService: DatabaseProtocol, news: NewsViewModel) {
    self.news = news
    self.databaseManager = loadService
  }
}

extension DetailesModel {
  func object() -> NewsViewModel {
    return news
  }

  func checkIsExistObjectInDatabase() {
    let lookingObject = databaseManager.checkObjectIsExistBy(id: news.urlNewsStr)
    guard lookingObject != nil else {
      saveNewsToDatabase()
      return
    }
    news.isNewsSaved = true
    output?.dataLoadSuccess()
  }

  private func saveNewsToDatabase() {
    let newsEntity = NewsEntity(
      author: news.author,
      title: news.title,
      descriptionNews: news.descriptionNews,
      urlNewsStr: news.urlNewsStr,
      urlToImageStr: news.urlToImageStr,
      publishedAtStr: news.publishedAtStr,
      content: news.content)
    if databaseManager.saveData(newsEntity: newsEntity) {
      checkIsExistObjectInDatabase()
    }
  }
}
