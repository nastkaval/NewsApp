//
//  NewsModel.swift
//  NewsApp
//
//  Created by Kovalchuk, Anastasiya on 10/27/20.
//  Copyright © 2020 Nastassia Kavalchuk. All rights reserved.
//

import Foundation

final class NewsModel {
  private var session = SessionData()
  var items: [News] = []

  weak var delegate: NewsDataSourceDelegate?
  private let apiManager: ApiManagerProtocol

  init(loadService: ApiManagerProtocol) {
    self.apiManager = loadService
  }
}

extension NewsModel: NewsDataSource {
  func items(filteredBy: String?) -> [News] {
    guard let keyWord = filteredBy else {
      delegate?.isFiltering = false
      return items
    }
    guard keyWord.count > 2 else {
      delegate?.isFiltering = false
      return items
    }
    let filteredArray = items.filter { $0.title.lowercased().contains("\(keyWord.lowercased())") }
    delegate?.isFiltering = true
    return filteredArray
  }

  func loadData(isNextPage: Bool) {
    if isNextPage {
      session.page += 1
    } else {
      session.page = 1
    }
    apiManager.callApi(session: session) { [weak self] result in
      switch result {
      case .success(let newsArray):
        self?.items.append(contentsOf: newsArray)
        self?.delegate?.dataLoadSuccess()
      case .failure(let error):
        self?.delegate?.dataLoadWithError(error.localizableDescription)
      }
    }
  }
}
