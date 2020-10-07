//
//  DetailesModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 9/30/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol DetailesModelOutput: class {
  func dataLoadSuccess()
  func dataLoadWithError(_ errorMessage: String)
}

final class DetailesModel {
  private var news: NewsViewModel
  private let databaseManager: DatabaseProtocol
  weak var output: DetailesModelOutput?

  init(dependency: ModelDependencyProtocol, news: NewsViewModel) {
    self.news = news
    self.databaseManager = dependency.databaseManager
  }
}

extension DetailesModel {
  func object() -> NewsViewModel {
    return news
  }

  func checkIsExistObjectInDatabase() {
    print("isSaved after opening == \(news.isNewsSaved)")
    if !news.isNewsSaved {
      let newsEntity = NewsEntity(
        author: news.author,
        title: news.title,
        descriptionNews: news.descriptionNews,
        urlNewsStr: news.urlNewsStr,
        urlToImageStr: news.urlToImageStr,
        publishedAtStr: news.publishedAtStr,
        content: news.content)
      if databaseManager.saveData(newsEntity: newsEntity) {
        news.isNewsSaved = true
        output?.dataLoadSuccess()
      }
    } else {
      output?.dataLoadSuccess()
    }
  }
}
