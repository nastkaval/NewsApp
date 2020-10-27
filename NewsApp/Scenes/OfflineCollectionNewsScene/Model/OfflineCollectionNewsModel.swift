//
//  OfflineCollectionNewsModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/06/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

protocol OfflineCollectionNewsModelOutput: AnyObject {
  func dataLoadSuccess()
  func dataLoadFailed()
  func dataRemovedSuccess()
  func dataRemovedFailed()
}

final class OfflineCollectionNewsModel {
  private var listNews: [News] = []
  private let databaseManager: DatabaseProtocol
  weak var output: OfflineCollectionNewsModelOutput?

  init(databaseManager: DatabaseProtocol) {
    self.databaseManager = databaseManager
  }

  // MARK: - Functions
  func loadDataFromDatabase() {
    let dataArray = databaseManager.loadData()
    guard !dataArray.isEmpty else {
      output?.dataLoadFailed()
      return
    }
    listNews = dataArray.map { item -> News in
      News(author: item.author, title: item.title, descriptionNews: item.descriptionNews, content: item.content, urlNewsStr: item.urlNewsStr, urlToImageStr: item.urlToImageStr, publishedAtStr: item.publishedAtStr)
    }
    output?.dataLoadSuccess()
  }

  func removeDataFromDatabase(from: Int) {
    let removeObjectId = object(from).urlNewsStr
    guard databaseManager.removeDataBy(id: removeObjectId) else {
      output?.dataRemovedFailed()
      return
    }
    listNews = listNews.filter { $0.urlNewsStr != removeObjectId }
    output?.dataRemovedSuccess()
  }
}

extension OfflineCollectionNewsModel {
  func object(_ index: Int) -> News {
    return listNews[index]
  }

  func count() -> Int {
    return listNews.count
  }

  var isModelEmpty: Bool {
    return listNews.isEmpty
  }
}
